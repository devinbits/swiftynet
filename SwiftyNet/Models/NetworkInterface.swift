import Foundation

struct NetworkInterface: Identifiable, Sendable, Equatable {
    let id: String
    let displayName: String
    let ipv4: String?
    let ipv6: String?
    let isActive: Bool

    var primaryAddress: String? {
        ipv4 ?? ipv6
    }

    var networkLabel: String {
        "\(displayName) (\(id))"
    }
}
