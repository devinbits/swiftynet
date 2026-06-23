import SwiftUI

struct ConnectivityBadge: View {
    let state: ConnectivityState

    var body: some View {
        Text(state.displayName)
            .captionStyle()
            .padding(.horizontal, DesignTokens.spacingS)
            .padding(.vertical, DesignTokens.spacingXS)
            .glassEffect(
                .regular.tint(AppColors.forConnectivity(state)),
                in: Capsule()
            )
    }
}
