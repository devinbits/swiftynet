import AppKit
import SwiftUI

enum WindowHelpers {
    @MainActor
    static func openDashboard(openWindow: OpenWindowAction) {
        NSApp.activate(ignoringOtherApps: true)
        openWindow(id: "dashboard")
    }

    @MainActor
    static func quit() {
        NSApp.terminate(nil)
    }
}
