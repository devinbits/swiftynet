import SwiftUI

struct ConnectivityBadge: View {
    let state: ConnectivityState

    private var statusColor: Color {
        AppColors.forConnectivity(state)
    }

    var body: some View {
        Text(state.displayName)
            .font(Typography.captionFont.weight(.semibold))
            .foregroundStyle(statusColor)
            .padding(.horizontal, DesignTokens.spacingS)
            .padding(.vertical, DesignTokens.spacingXS)
            .background(statusColor.opacity(0.14), in: Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(statusColor.opacity(0.4), lineWidth: 1)
            }
    }
}
