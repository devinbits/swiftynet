import SwiftUI

struct SpeedCardView: View {
    let downloadSpeed: Double
    let uploadSpeed: Double
    let monitoringEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
            HStack(spacing: DesignTokens.spacingXL) {
                SpeedDisplay(
                    label: "Download",
                    icon: "arrow.down",
                    bytesPerSecond: downloadSpeed,
                    monitoringEnabled: monitoringEnabled
                )

                SpeedDisplay(
                    label: "Upload",
                    icon: "arrow.up",
                    bytesPerSecond: uploadSpeed,
                    monitoringEnabled: monitoringEnabled
                )
            }

            if !monitoringEnabled {
                Text("Speeds update when monitoring is enabled.")
                    .captionStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
