import SwiftUI

enum DesignTokens {
    static let spacingXS: CGFloat = 4
    static let spacingS: CGFloat = 8
    static let spacingM: CGFloat = 12
    static let spacingL: CGFloat = 16
    static let spacingXL: CGFloat = 20
    static let spacingXXL: CGFloat = 24

    static let radiusS: CGFloat = 8
    static let radiusM: CGFloat = 12
    static let radiusL: CGFloat = 16
    static let radiusXL: CGFloat = 20

    static let rowHeight: CGFloat = 44
    static let minWindowWidth: CGFloat = 400
    static let minWindowHeight: CGFloat = 480

    static var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: radiusL, style: .continuous)
    }
}
