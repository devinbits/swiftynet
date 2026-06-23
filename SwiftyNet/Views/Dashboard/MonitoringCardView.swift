import SwiftUI

struct MonitoringCardView: View {
    @Bindable var monitor: NetworkMonitorService

    var body: some View {
        let showIPv6 = monitor.showIPv6InMenuBar
        let _ = monitor.preferencesChangeToken

        VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
            HStack {
                ConnectivityBadge(state: monitor.connectivity)
                Spacer()
                Toggle("Enable", isOn: $monitor.isMonitoringEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            MetricRow(
                icon: "network",
                label: "Network",
                value: Formatters.networkLabel(for: monitor.primaryInterface)
            )

            MetricRow(
                icon: "number",
                label: "IP",
                value: Formatters.address(
                    for: monitor.primaryInterface,
                    showIPv6: showIPv6
                )
            )

            if !monitor.isMonitoringEnabled {
                Text("Enable monitoring to track live speed and connection changes.")
                    .captionStyle()
            }
        }
    }
}
