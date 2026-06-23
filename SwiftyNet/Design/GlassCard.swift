import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(DesignTokens.spacingL)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: DesignTokens.cardShape)
    }
}

struct DividerInset: View {
    var body: some View {
        Divider()
            .padding(.leading, DesignTokens.spacingL)
    }
}
