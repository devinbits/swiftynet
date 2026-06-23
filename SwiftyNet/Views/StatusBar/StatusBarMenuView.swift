import SwiftUI

struct StatusBarMenuView: View {
    @Bindable var monitor: NetworkMonitorService
    @Bindable private var preferences = MonitoringPreferences.shared
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Group {
            statusButton(
                title: "Connection: \(monitor.connectivity.displayName)",
                subtitle: monitor.isMonitoringEnabled ? nil : "Enable in Dashboard"
            )

            statusButton(
                title: "Network: \(Formatters.networkLabel(for: monitor.primaryInterface))"
            )

            statusButton(
                title: "IP: \(Formatters.address(for: monitor.primaryInterface, showIPv6: preferences.showIPv6InMenuBar))"
            )

            statusButton(
                title: "Speed: \(Formatters.speedPair(download: monitor.downloadSpeed, upload: monitor.uploadSpeed, monitoringEnabled: monitor.isMonitoringEnabled))"
            )

            Divider()

            Button("Open Dashboard") {
                WindowHelpers.openDashboard(openWindow: openWindow)
            }

            Button("Quit SwiftyNet") {
                WindowHelpers.quit()
            }
        }
    }

    @ViewBuilder
    private func statusButton(title: String, subtitle: String? = nil) -> some View {
        Button {
            WindowHelpers.openDashboard(openWindow: openWindow)
        } label: {
            if let subtitle {
                VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                    Text(title)
                    Text(subtitle)
                        .font(Typography.captionFont)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(title)
            }
        }
    }
}
