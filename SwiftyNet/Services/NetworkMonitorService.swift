import Foundation
import Network
import Observation

@Observable
@MainActor
final class NetworkMonitorService {
    private(set) var connectivity: ConnectivityState = .offline
    private(set) var primaryInterface: NetworkInterface?
    private(set) var allInterfaces: [NetworkInterface] = []
    private(set) var downloadSpeed: Double = 0
    private(set) var uploadSpeed: Double = 0

    var isMonitoringEnabled: Bool {
        get { preferences.isMonitoringEnabled }
        set {
            preferences.isMonitoringEnabled = newValue
            if newValue {
                startMonitoring()
            } else {
                stopMonitoring()
                connectivity = .monitoringOff
                downloadSpeed = 0
                uploadSpeed = 0
                refreshLightweightSnapshot()
            }
        }
    }

    var statusIcon: String {
        if !isMonitoringEnabled {
            return "network"
        }

        switch connectivity {
        case .online:
            if primaryInterface?.displayName.lowercased().contains("wi-fi") == true
                || primaryInterface?.id.hasPrefix("en") == true && primaryInterface?.displayName != "Ethernet" {
                return "wifi"
            }
            return "cable.connector"
        case .localOnly:
            return "wifi.exclamationmark"
        case .offline:
            return "wifi.slash"
        case .monitoringOff:
            return "network"
        }
    }

    private let preferences = MonitoringPreferences.shared
    private nonisolated(unsafe) var pathMonitor: NWPathMonitor?
    private let monitorQueue = DispatchQueue(label: "com.labs.SwiftyNet.pathMonitor")
    private let speedCalculator = SpeedCalculator()

    private nonisolated(unsafe) var speedTimer: Timer?
    private var currentPath: NWPath?
    private var activeInterfaceName: String?
    private var hasInternet: Bool = false
    private nonisolated(unsafe) var lightweightMonitor: NWPathMonitor?

    init() {
        if preferences.isMonitoringEnabled {
            startMonitoring()
        } else {
            connectivity = .monitoringOff
            startLightweightMonitor()
        }
    }

    func restartSpeedPolling() {
        guard isMonitoringEnabled else { return }
        speedTimer?.invalidate()
        speedTimer = Timer.scheduledTimer(withTimeInterval: preferences.speedPollInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.sampleSpeed()
            }
        }
        if let speedTimer {
            RunLoop.main.add(speedTimer, forMode: .common)
        }
    }

    func refreshSnapshot() {
        let interfaces = InterfaceDiscovery.discoverInterfaces(activeInterfaceName: activeInterfaceName)
        allInterfaces = interfaces

        if let preferredId = preferences.preferredInterfaceId,
           let preferred = interfaces.first(where: { $0.id == preferredId }) {
            primaryInterface = preferred
        } else {
            primaryInterface = interfaces.first(where: \.isActive) ?? interfaces.first
        }

        if !isMonitoringEnabled {
            connectivity = .monitoringOff
            return
        }

        connectivity = resolveConnectivity()
    }

    private func startMonitoring() {
        stopLightweightMonitor()
        speedCalculator.reset(for: activeInterfaceName)

        let monitor = NWPathMonitor()
        pathMonitor = monitor
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.handlePathUpdate(path)
            }
        }
        monitor.start(queue: monitorQueue)

        speedTimer?.invalidate()
        speedTimer = Timer.scheduledTimer(withTimeInterval: preferences.speedPollInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.sampleSpeed()
            }
        }
        if let speedTimer {
            RunLoop.main.add(speedTimer, forMode: .common)
        }
    }

    private func stopMonitoring() {
        pathMonitor?.cancel()
        pathMonitor = nil
        speedTimer?.invalidate()
        speedTimer = nil
        currentPath = nil
        activeInterfaceName = nil
        hasInternet = false
        startLightweightMonitor()
    }

    private func startLightweightMonitor() {
        guard lightweightMonitor == nil else { return }

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                guard let self, !self.isMonitoringEnabled else { return }
                self.currentPath = path
                self.activeInterfaceName = Self.primaryInterfaceName(from: path)
                self.hasInternet = path.status == .satisfied
                self.refreshLightweightSnapshot()
            }
        }
        monitor.start(queue: monitorQueue)
        lightweightMonitor = monitor
    }

    private func stopLightweightMonitor() {
        lightweightMonitor?.cancel()
        lightweightMonitor = nil
    }

    private func handlePathUpdate(_ path: NWPath) {
        currentPath = path
        activeInterfaceName = Self.primaryInterfaceName(from: path)
        hasInternet = path.status == .satisfied
        refreshSnapshot()
    }

    private func refreshLightweightSnapshot() {
        let interfaces = InterfaceDiscovery.discoverInterfaces(activeInterfaceName: activeInterfaceName)
        allInterfaces = interfaces
        primaryInterface = interfaces.first(where: \.isActive) ?? interfaces.first

        if !isMonitoringEnabled {
            if hasInternet {
                connectivity = .online
            } else if currentPath?.status == .requiresConnection {
                connectivity = .localOnly
            } else {
                connectivity = .offline
            }
        }
    }

    private func sampleSpeed() {
        let interfaceName = primaryInterface?.id ?? activeInterfaceName
        let traffic = InterfaceDiscovery.traffic(for: interfaceName)
        let sample = speedCalculator.update(traffic: traffic)
        downloadSpeed = sample.downloadBytesPerSecond
        uploadSpeed = sample.uploadBytesPerSecond
        refreshSnapshot()
    }

    private func resolveConnectivity() -> ConnectivityState {
        guard let currentPath else { return .offline }

        switch currentPath.status {
        case .satisfied:
            return .online
        case .requiresConnection:
            return .localOnly
        case .unsatisfied:
            return .offline
        @unknown default:
            return .offline
        }
    }

    private static func primaryInterfaceName(from path: NWPath) -> String? {
        path.availableInterfaces.first?.name
    }

    deinit {
        pathMonitor?.cancel()
        lightweightMonitor?.cancel()
        speedTimer?.invalidate()
    }
}
