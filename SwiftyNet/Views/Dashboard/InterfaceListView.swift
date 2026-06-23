import SwiftUI

struct InterfaceListView: View {
    let interfaces: [NetworkInterface]

    var body: some View {
        if interfaces.isEmpty {
            Text("No network interfaces detected.")
                .secondaryLabelStyle()
                .frame(maxWidth: .infinity, minHeight: DesignTokens.rowHeight, alignment: .leading)
        } else {
            VStack(spacing: 0) {
                ForEach(Array(interfaces.enumerated()), id: \.element.id) { index, interface in
                    InterfaceRow(interface: interface)

                    if index < interfaces.count - 1 {
                        DividerInset()
                    }
                }
            }
        }
    }
}
