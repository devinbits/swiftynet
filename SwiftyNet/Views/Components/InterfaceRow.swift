import SwiftUI

struct InterfaceRow: View {
    let interface: NetworkInterface

    var body: some View {
        HStack(spacing: DesignTokens.spacingS) {
            Image(systemName: interface.isActive ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(interface.isActive ? AppColors.accent : AppColors.statusIdle)
                .frame(width: DesignTokens.spacingL)

            VStack(alignment: .leading, spacing: DesignTokens.spacingXS) {
                Text(interface.networkLabel)
                    .bodyLabelStyle()
                Text(interface.primaryAddress ?? Formatters.placeholder)
                    .secondaryLabelStyle()
                    .monospacedDigit()
            }

            Spacer(minLength: DesignTokens.spacingM)

            Text(interface.isActive ? "Active" : "Idle")
                .captionStyle()
        }
        .frame(minHeight: DesignTokens.rowHeight)
    }
}
