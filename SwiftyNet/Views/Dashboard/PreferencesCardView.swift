import SwiftUI

struct PreferencesCardView: View {
    @Bindable var monitor: NetworkMonitorService
    @Bindable private var preferences = MonitoringPreferences.shared

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingM) {
            Toggle("Show IPv6 in Menu Bar", isOn: $preferences.showIPv6InMenuBar)

            Picker("Preferred Interface", selection: preferredInterfaceBinding) {
                Text("System Default").tag(Optional<String>.none)
                ForEach(monitor.allInterfaces) { interface in
                    Text(interface.networkLabel).tag(Optional(interface.id))
                }
            }

            HStack {
                Text("Speed Poll Interval")
                    .secondaryLabelStyle()
                Spacer()
                Text("\(preferences.speedPollInterval, specifier: "%.1f")s")
                    .menuBarValueStyle()
            }

            Slider(value: $preferences.speedPollInterval, in: 0.5...3.0, step: 0.5)
                .onChange(of: preferences.speedPollInterval) { _, _ in
                    if monitor.isMonitoringEnabled {
                        monitor.restartSpeedPolling()
                    }
                }
        }
    }

    private var preferredInterfaceBinding: Binding<String?> {
        Binding(
            get: { preferences.preferredInterfaceId },
            set: { preferences.preferredInterfaceId = $0 }
        )
    }
}
