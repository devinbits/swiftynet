import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(DesignTokens.cardPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular, in: DesignTokens.cardShape)
            .overlay {
                DesignTokens.cardShape
                    .strokeBorder(.primary.opacity(0.1), lineWidth: 0.5)
            }
    }
}

struct DividerInset: View {
    var body: some View {
        Divider()
            .padding(.leading, DesignTokens.spacingL)
    }
}
