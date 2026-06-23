import SwiftUI

struct DashboardView: View {
    @Bindable var monitor: NetworkMonitorService
    @Bindable private var preferences = MonitoringPreferences.shared

    var body: some View {
        let showIPv6 = monitor.showIPv6InMenuBar
        let _ = monitor.preferencesChangeToken

        ScreenContainer {
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

                VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
                    SectionHeader("Interfaces")
                    GlassCard {
                        InterfaceListView(
                            interfaces: monitor.allInterfaces,
                            preferredInterfaceId: preferences.preferredInterfaceId,
                            showIPv6: showIPv6
                        )
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
        .containerBackground(.thickMaterial, for: .window)
        .toolbarBackground(.thickMaterial, for: .windowToolbar)
        .toolbarBackgroundVisibility(.visible, for: .windowToolbar)
    }
}
