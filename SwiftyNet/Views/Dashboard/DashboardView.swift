import SwiftUI

struct DashboardView: View {
    @Bindable var monitor: NetworkMonitorService

    var body: some View {
        ScreenContainer {
            VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {
                GlassEffectContainer(spacing: DesignTokens.spacingM) {
                    VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {
                        VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                            SectionHeader("Monitoring")
                            GlassCard {
                                MonitoringCardView(monitor: monitor)
                            }
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

                VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                    SectionHeader("Preferences")
                    GlassCard {
                        PreferencesCardView(monitor: monitor)
                    }
                }
            }
        }
        .backgroundExtensionEffect()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SwiftyNet")
                    .windowTitleStyle()
            }
        }
    }
}
