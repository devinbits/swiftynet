import SwiftUI

struct InterfaceListView: View {
    let interfaces: [NetworkInterface]
    let preferredInterfaceId: String?
    let showIPv6: Bool

    var body: some View {
        if interfaces.isEmpty {
            Text("No network interfaces detected.")
                .secondaryLabelStyle()
                .frame(maxWidth: .infinity, minHeight: DesignTokens.rowHeight, alignment: .leading)
        } else {
            VStack(spacing: 0) {
                ForEach(Array(interfaces.enumerated()), id: \.element.id) { index, interface in
                    InterfaceRow(
                        interface: interface,
                        showIPv6: showIPv6,
                        isPreferred: interface.id == preferredInterfaceId
                    )

                    if index < interfaces.count - 1 {
                        DividerInset()
                    }
                }
            }
        }
    }
}
