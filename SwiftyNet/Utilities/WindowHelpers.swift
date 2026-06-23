import AppKit
import SwiftUI

enum WindowHelpers {
    private static let dashboardWindowID = "dashboard"

    @MainActor
    static func openDashboard(openWindow: OpenWindowAction) {
        NSApp.activate(ignoringOtherApps: true)

        // Defer until after the menu finishes dismissing; opening synchronously
        // from MenuBarExtra menu actions can crash on some macOS versions.
        DispatchQueue.main.async {
            if let existingWindow = dashboardWindow() {
                existingWindow.makeKeyAndOrderFront(nil)
                existingWindow.orderFrontRegardless()
                return
            }

            openWindow(id: dashboardWindowID)

            DispatchQueue.main.async {
                dashboardWindow()?.makeKeyAndOrderFront(nil)
            }
        }
    }

    @MainActor
    static func quit() {
        NSApp.terminate(nil)
    }

    @MainActor
    private static func dashboardWindow() -> NSWindow? {
        NSApp.windows.first { window in
            window.identifier?.rawValue == dashboardWindowID || window.title == "SwiftyNet"
        }
    }
}
