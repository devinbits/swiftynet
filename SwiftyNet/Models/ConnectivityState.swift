import Foundation

enum ConnectivityState: String, Sendable {
    case online
    case localOnly
    case offline
    case monitoringOff

    var displayName: String {
        switch self {
        case .online:
            "Online"
        case .localOnly:
            "Local Network"
        case .offline:
            "No Internet"
        case .monitoringOff:
            "Monitoring Off"
        }
    }
}
