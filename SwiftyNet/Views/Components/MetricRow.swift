import SwiftUI

struct MetricRow: View {
    let icon: String?
    let label: String
    let value: String

    init(icon: String? = nil, label: String, value: String) {
        self.icon = icon
        self.label = label
        self.value = value
    }

    var body: some View {
        HStack(spacing: DesignTokens.spacingS) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .frame(width: DesignTokens.spacingL)
            }

            Text(label)
                .secondaryLabelStyle()

            Spacer(minLength: DesignTokens.spacingM)

            Text(value)
                .menuBarValueStyle()
                .multilineTextAlignment(.trailing)
        }
        .frame(height: DesignTokens.rowHeight)
    }
}
