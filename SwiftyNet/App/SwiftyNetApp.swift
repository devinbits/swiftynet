import SwiftUI

@main
struct SwiftyNetApp: App {
    @State private var monitor = NetworkMonitorService()

    var body: some Scene {
        MenuBarExtra("SwiftyNet", systemImage: monitor.statusIcon) {
            StatusBarMenuView(monitor: monitor)
        }
        .menuBarExtraStyle(.menu)

        Window("SwiftyNet", id: "dashboard") {
            DashboardView(monitor: monitor)
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentSize)
        .defaultSize(
            width: DesignTokens.minWindowWidth,
            height: DesignTokens.minWindowHeight
        )
    }
}
