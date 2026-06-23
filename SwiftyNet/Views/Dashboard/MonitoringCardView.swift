import SwiftUI

struct MonitoringCardView: View {
    @Bindable var monitor: NetworkMonitorService

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
            HStack {
                Text("Monitoring")
                    .sectionHeaderStyle()
                Spacer()
                Toggle("Enable", isOn: $monitor.isMonitoringEnabled)
                    .toggleStyle(.switch)
                    .labelsHidden()
            }

            HStack(spacing: DesignTokens.spacingS) {
                ConnectivityBadge(state: monitor.connectivity)

                if let interface = monitor.primaryInterface {
                    Text(interface.networkLabel)
                        .secondaryLabelStyle()
                } else {
                    Text(Formatters.placeholder)
                        .secondaryLabelStyle()
                }
            }

            if let address = monitor.primaryInterface?.primaryAddress {
                Text(address)
                    .metricValueStyle()
                    .monospacedDigit()
            } else {
                Text(Formatters.placeholder)
                    .metricValueStyle()
            }

            if !monitor.isMonitoringEnabled {
                Text("Enable monitoring to track live speed and connection changes.")
                    .captionStyle()
            }
        }
    }
}
