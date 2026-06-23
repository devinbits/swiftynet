import SwiftUI

struct SpeedDisplay: View {
    let label: String
    let icon: String
    let bytesPerSecond: Double
    let monitoringEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
            Label(label, systemImage: icon)
                .secondaryLabelStyle()

            Text(Formatters.speed(bytesPerSecond, monitoringEnabled: monitoringEnabled))
                .metricValueStyle()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
