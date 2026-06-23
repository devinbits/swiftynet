import SwiftUI

enum Typography {
    static var windowTitleFont: Font {
        .title2.weight(.semibold)
    }

    static var sectionHeaderFont: Font {
        .headline.weight(.semibold)
    }

    static var metricValueFont: Font {
        .title3.weight(.medium).monospacedDigit()
    }

    static var bodyLabelFont: Font {
        .body
    }

    static var secondaryLabelFont: Font {
        .subheadline
    }

    static var captionFont: Font {
        .caption
    }

    static var menuBarValueFont: Font {
        .body.weight(.medium).monospacedDigit()
    }
}

extension View {
    func windowTitleStyle() -> some View {
        font(Typography.windowTitleFont)
    }

    func sectionHeaderStyle() -> some View {
        font(Typography.sectionHeaderFont)
    }

    func metricValueStyle() -> some View {
        font(Typography.metricValueFont)
    }

    func bodyLabelStyle() -> some View {
        font(Typography.bodyLabelFont)
    }

    func secondaryLabelStyle() -> some View {
        font(Typography.secondaryLabelFont)
            .foregroundStyle(.secondary)
    }

    func captionStyle() -> some View {
        font(Typography.captionFont)
            .foregroundStyle(.secondary)
    }

    func menuBarValueStyle() -> some View {
        font(Typography.menuBarValueFont)
    }
}
