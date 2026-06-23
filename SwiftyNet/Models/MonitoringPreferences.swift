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

    static let allowedSpeedPollIntervals: [TimeInterval] = [1, 2, 3, 5]

    var isMonitoringEnabled: Bool {
        didSet { defaults.set(isMonitoringEnabled, forKey: Keys.isMonitoringEnabled) }
    }

    var preferredInterfaceId: String? {
        didSet {
            if let preferredInterfaceId {
                defaults.set(preferredInterfaceId, forKey: Keys.preferredInterfaceId)
            } else {
                defaults.removeObject(forKey: Keys.preferredInterfaceId)
            }
        }
    }

    var speedPollInterval: TimeInterval {
        didSet {
            let normalized = Self.normalizeSpeedPollInterval(speedPollInterval)
            if normalized != speedPollInterval {
                speedPollInterval = normalized
            } else {
                defaults.set(speedPollInterval, forKey: Keys.speedPollInterval)
            }
        }
    }

    var showIPv6InMenuBar: Bool {
        didSet { defaults.set(showIPv6InMenuBar, forKey: Keys.showIPv6InMenuBar) }
    }

    private init() {
        isMonitoringEnabled = defaults.bool(forKey: Keys.isMonitoringEnabled)
        preferredInterfaceId = defaults.string(forKey: Keys.preferredInterfaceId)
        let storedInterval = defaults.double(forKey: Keys.speedPollInterval)
        speedPollInterval = Self.normalizeSpeedPollInterval(storedInterval > 0 ? storedInterval : 1)
        showIPv6InMenuBar = defaults.bool(forKey: Keys.showIPv6InMenuBar)
    }

    static func normalizeSpeedPollInterval(_ value: TimeInterval) -> TimeInterval {
        allowedSpeedPollIntervals.contains(value) ? value : 1
    }
}
