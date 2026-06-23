import SwiftUI

struct InterfaceRow: View {
    let interface: NetworkInterface
    let showIPv6: Bool
    let isPreferred: Bool

    var body: some View {
        HStack(spacing: DesignTokens.spacingS) {
            Image(systemName: interface.isActive ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(interface.isActive ? AppColors.accent : AppColors.statusIdle)
                .frame(width: DesignTokens.spacingL)

            VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                Text(interface.networkLabel)
                    .bodyLabelStyle()
                Text(Formatters.address(for: interface, showIPv6: showIPv6))
                    .secondaryLabelStyle()
                    .monospacedDigit()
            }

            Spacer(minLength: DesignTokens.spacingM)

            if isPreferred {
                Text("Preferred")
                    .captionStyle()
            } else {
                Text(interface.isActive ? "Active" : "Idle")
                    .captionStyle()
            }
        }
        .frame(minHeight: DesignTokens.rowHeightCompact)
    }
}
