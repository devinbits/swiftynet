import SwiftUI

struct DashboardView: View {
    @Bindable var monitor: NetworkMonitorService

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {
                GlassEffectContainer(spacing: DesignTokens.spacingM) {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {
                        GlassCard {
                            MonitoringCardView(monitor: monitor)
                        }

                        VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                            SectionHeader("Speed")
                            GlassCard {
                                SpeedCardView(
                                    downloadSpeed: monitor.downloadSpeed,
                                    uploadSpeed: monitor.uploadSpeed,
                                    monitoringEnabled: monitor.isMonitoringEnabled
                                )
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                    SectionHeader("Interfaces")
                    GlassCard {
                        InterfaceListView(interfaces: monitor.allInterfaces)
                    }
                }
            }
        }
        .containerBackground(.thickMaterial, for: .window)
        .toolbarBackground(.thickMaterial, for: .windowToolbar)
        .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
    }
}
