import SwiftUI

struct SpeedCardView: View {
    let downloadSpeed: Double
    let uploadSpeed: Double
    let monitoringEnabled: Bool

    var body: some View {
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
    }
}
