import SwiftUI

struct PreferencesCardView: View {
    @Bindable var monitor: NetworkMonitorService

    var body: some View {
        VStack(alignment: .leading, spacing: DesignTokens.spacingS) {
            Toggle("Show IPv6 in Menu Bar", isOn: $monitor.showIPv6InMenuBar)

            Picker("Preferred Interface", selection: preferredInterfaceBinding) {
                Text("System Default").tag(Optional<String>.none)
                ForEach(monitor.allInterfaces) { interface in
                    Text(interface.networkLabel).tag(Optional(interface.id))
                }
            }
            .pickerStyle(.menu)

            Picker("Speed Poll Interval", selection: speedPollIntervalBinding) {
                ForEach(MonitoringPreferences.allowedSpeedPollIntervals, id: \.self) { interval in
                    Text("\(Int(interval))s").tag(interval)
                }
            }
            .pickerStyle(.menu)
        }
    }

    private var preferredInterfaceBinding: Binding<String?> {
        Binding(
            get: { MonitoringPreferences.shared.preferredInterfaceId },
            set: { newValue in
                MonitoringPreferences.shared.preferredInterfaceId = newValue
                monitor.refreshSnapshot()
            }
        )
    }

    private var speedPollIntervalBinding: Binding<TimeInterval> {
        Binding(
            get: { MonitoringPreferences.shared.speedPollInterval },
            set: { newValue in
                MonitoringPreferences.shared.speedPollInterval = newValue
                if monitor.isMonitoringEnabled {
                    monitor.restartSpeedPolling()
                }
            }
        )
    }
}
