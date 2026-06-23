import Foundation
import SystemConfiguration

struct InterfaceTraffic: Sendable {
    let interfaceName: String
    let inputBytes: UInt64
    let outputBytes: UInt64
}

enum InterfaceDiscovery {
    static func discoverInterfaces(activeInterfaceName: String?) -> [NetworkInterface] {
        var addressesByInterface: [String: (ipv4: String?, ipv6: String?)] = [:]

        var ifaddrPointer: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrPointer) == 0, let firstAddr = ifaddrPointer else {
            return []
        }
        defer { freeifaddrs(ifaddrPointer) }

        var pointer: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while let current = pointer {
            let interfaceName = String(cString: current.pointee.ifa_name)
            guard let addressPointer = current.pointee.ifa_addr else {
                pointer = current.pointee.ifa_next
                continue
            }

            if addressPointer.pointee.sa_family == UInt8(AF_INET) {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(
                    addressPointer,
                    socklen_t(addressPointer.pointee.sa_len),
                    &hostname,
                    socklen_t(hostname.count),
                    nil,
                    0,
                    NI_NUMERICHOST
                ) == 0 {
                    let address = String(cString: hostname)
                    var entry = addressesByInterface[interfaceName] ?? (nil, nil)
                    entry.ipv4 = address
                    addressesByInterface[interfaceName] = entry
                }
            }

            if addressPointer.pointee.sa_family == UInt8(AF_INET6) {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                if getnameinfo(
                    addressPointer,
                    socklen_t(addressPointer.pointee.sa_len),
                    &hostname,
                    socklen_t(hostname.count),
                    nil,
                    0,
                    NI_NUMERICHOST
                ) == 0 {
                    let address = String(cString: hostname)
                    let hostOnly = address.split(separator: "%").first.map(String.init) ?? address
                    guard isUsableIPv6(hostOnly) else {
                        pointer = current.pointee.ifa_next
                        continue
                    }

                    var entry = addressesByInterface[interfaceName] ?? (nil, nil)
                    if let existingIPv6 = entry.ipv6 {
                        entry.ipv6 = preferredIPv6(existingIPv6, hostOnly)
                    } else {
                        entry.ipv6 = hostOnly
                    }
                    addressesByInterface[interfaceName] = entry
                }
            }

            pointer = current.pointee.ifa_next
        }

        let displayNames = localizedDisplayNames()

        return addressesByInterface
            .filter { name, addresses in
                !name.hasPrefix("lo") && (addresses.ipv4 != nil || addresses.ipv6 != nil)
            }
            .map { name, addresses in
                NetworkInterface(
                    id: name,
                    displayName: displayNames[name] ?? name,
                    ipv4: addresses.ipv4,
                    ipv6: addresses.ipv6,
                    isActive: name == activeInterfaceName
                )
            }
            .sorted { lhs, rhs in
                if lhs.isActive != rhs.isActive {
                    return lhs.isActive
                }
                return lhs.id < rhs.id
            }
    }

    static func traffic(for interfaceName: String?) -> InterfaceTraffic? {
        guard let interfaceName else { return nil }

        var ifaddrPointer: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddrPointer) == 0, let firstAddr = ifaddrPointer else {
            return nil
        }
        defer { freeifaddrs(ifaddrPointer) }

        var pointer: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while let current = pointer {
            let name = String(cString: current.pointee.ifa_name)
            if name == interfaceName, let data = current.pointee.ifa_data?.assumingMemoryBound(to: if_data.self) {
                return InterfaceTraffic(
                    interfaceName: name,
                    inputBytes: UInt64(data.pointee.ifi_ibytes),
                    outputBytes: UInt64(data.pointee.ifi_obytes)
                )
            }
            pointer = current.pointee.ifa_next
        }

        return nil
    }

    private static func isUsableIPv6(_ address: String) -> Bool {
        !address.hasPrefix("fe80") && address != "::1"
    }

    private static func preferredIPv6(_ current: String, _ candidate: String) -> String {
        ipv6PreferenceScore(candidate) > ipv6PreferenceScore(current) ? candidate : current
    }

    private static func ipv6PreferenceScore(_ address: String) -> Int {
        if address.hasPrefix("fe80") || address == "::1" { return 0 }
        if address.hasPrefix("fd") || address.hasPrefix("fc") { return 1 }
        return 2
    }

    private static func localizedDisplayNames() -> [String: String] {
        guard let interfaces = SCNetworkInterfaceCopyAll() as? [SCNetworkInterface] else {
            return [:]
        }

        var names: [String: String] = [:]
        for interface in interfaces {
            let bsdName = SCNetworkInterfaceGetBSDName(interface) as String? ?? ""
            let displayName = SCNetworkInterfaceGetLocalizedDisplayName(interface) as String? ?? bsdName
            if !bsdName.isEmpty {
                names[bsdName] = displayName
            }
        }
        return names
    }
}
