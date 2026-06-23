import Foundation

enum Formatters {
    static let placeholder = "—"

    private static func makeSpeedFormatter() -> ByteCountFormatter {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .binary
        formatter.includesUnit = true
        formatter.isAdaptive = true
        return formatter
    }

    static func speed(_ bytesPerSecond: Double, monitoringEnabled: Bool) -> String {
        guard monitoringEnabled else {
            return placeholder
        }

        let clamped = max(0, bytesPerSecond)
        guard clamped >= 1 else {
            return "0 KB/s"
        }

        return "\(makeSpeedFormatter().string(fromByteCount: Int64(clamped)))/s"
    }

    static func speedPair(download: Double, upload: Double, monitoringEnabled: Bool) -> String {
        guard monitoringEnabled else { return placeholder }
        return "↓ \(speed(download, monitoringEnabled: true))  ↑ \(speed(upload, monitoringEnabled: true))"
    }

    static func menuSpeedLine(download: Double, upload: Double, monitoringEnabled: Bool) -> String {
        "Speed: \(speedPair(download: download, upload: upload, monitoringEnabled: monitoringEnabled))"
    }

    static func address(for interface: NetworkInterface?, showIPv6: Bool) -> String {
        guard let interface else { return placeholder }
        if showIPv6, let ipv6 = interface.ipv6 {
            return ipv6
        }
        return interface.ipv4 ?? interface.ipv6 ?? placeholder
    }

    static func networkLabel(for interface: NetworkInterface?) -> String {
        guard let interface else { return placeholder }
        return interface.networkLabel
    }
}
