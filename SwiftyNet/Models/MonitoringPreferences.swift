import Foundation
import Observation

@Observable
@MainActor
final class MonitoringPreferences {
    static let shared = MonitoringPreferences()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let isMonitoringEnabled = "isMonitoringEnabled"
        static let preferredInterfaceId = "preferredInterfaceId"
        static let speedPollInterval = "speedPollInterval"
        static let showIPv6InMenuBar = "showIPv6InMenuBar"
    }

    var isMonitoringEnabled: Bool {
        get { defaults.bool(forKey: Keys.isMonitoringEnabled) }
        set { defaults.set(newValue, forKey: Keys.isMonitoringEnabled) }
    }

    var preferredInterfaceId: String? {
        get { defaults.string(forKey: Keys.preferredInterfaceId) }
        set { defaults.set(newValue, forKey: Keys.preferredInterfaceId) }
    }

    var speedPollInterval: TimeInterval {
        get {
            let value = defaults.double(forKey: Keys.speedPollInterval)
            return value > 0 ? value : 1.0
        }
        set { defaults.set(newValue, forKey: Keys.speedPollInterval) }
    }

    var showIPv6InMenuBar: Bool {
        get { defaults.bool(forKey: Keys.showIPv6InMenuBar) }
        set { defaults.set(newValue, forKey: Keys.showIPv6InMenuBar) }
    }
}
