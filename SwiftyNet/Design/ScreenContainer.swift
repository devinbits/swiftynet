import SwiftUI

struct ScreenContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignTokens.spacingXL) {
                content
            }
            .padding(DesignTokens.spacingXXL)
            .frame(
                minWidth: DesignTokens.minWindowWidth - DesignTokens.spacingXXL * 2,
                alignment: .leading
            )
        }
        .frame(
            width: DesignTokens.minWindowWidth,
            height: DesignTokens.minWindowHeight
        )
    }
}
