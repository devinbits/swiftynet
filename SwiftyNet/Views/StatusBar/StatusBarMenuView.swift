import SwiftUI

struct StatusBarMenuView: View {
    @Bindable var monitor: NetworkMonitorService
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        let showIPv6 = monitor.showIPv6InMenuBar
        let _ = monitor.preferencesChangeToken

        Group {
            statusButton(
                title: "Monitoring: \(monitor.monitoringStatusLabel)",
                subtitle: monitor.isMonitoringEnabled ? nil : "Enable in Dashboard",
                indicatorColor: monitor.isMonitoringEnabled ? AppColors.statusMonitoringActive : nil
            )

            statusButton(
                title: "Connection: \(monitor.connectivity.displayName)",
                indicatorColor: monitor.connectivity == .online
                    ? AppColors.statusOnline
                    : AppColors.statusOffline
            )

            statusButton(
                title: "Network: \(Formatters.networkLabel(for: monitor.primaryInterface))"
            )

            statusButton(
                title: "IP: \(Formatters.address(for: monitor.primaryInterface, showIPv6: showIPv6))"
            )

            speedStatusButton(
                download: monitor.downloadSpeed,
                upload: monitor.uploadSpeed,
                monitoringEnabled: monitor.isMonitoringEnabled
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
    private func statusButton(
        title: String,
        subtitle: String? = nil,
        indicatorColor: Color? = nil
    ) -> some View {
        Button {
            WindowHelpers.openDashboard(openWindow: openWindow)
        } label: {
            HStack(spacing: DesignTokens.spacingS) {
                if let indicatorColor {
                    StatusIndicator(color: indicatorColor)
                }

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

    private func speedStatusButton(
        download: Double,
        upload: Double,
        monitoringEnabled: Bool
    ) -> some View {
        Button {
            WindowHelpers.openDashboard(openWindow: openWindow)
        } label: {
            Text(Formatters.menuSpeedLine(
                download: download,
                upload: upload,
                monitoringEnabled: monitoringEnabled
            ))
            .menuBarValueStyle()
            .frame(width: DesignTokens.menuBarSpeedRowWidth, alignment: .leading)
        }
    }
}

private struct StatusIndicator: View {
    let color: Color

    var body: some View {
        Circle()
            .fill(color)
            .frame(
                width: DesignTokens.statusIndicatorSize,
                height: DesignTokens.statusIndicatorSize
            )
    }
}
