import SwiftUI

enum AppColors {
    static let statusOnline = Color.green
    static let statusOffline = Color.red
    static let statusLocal = Color.orange
    static let statusIdle = Color.secondary
    static let accent = Color.accentColor

    static func forConnectivity(_ state: ConnectivityState) -> Color {
        switch state {
        case .online:
            statusOnline
        case .localOnly:
            statusLocal
        case .offline:
            statusOffline
        case .monitoringOff:
            statusIdle
        }
    }
}
