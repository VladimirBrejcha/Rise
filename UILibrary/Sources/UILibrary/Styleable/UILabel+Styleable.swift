import UIKit

extension UILabel: Styleable {
    public func applyStyle(_ style: Style.Text) {
        self.font = style.font
        if let color = style.color {
            self.textColor = color
        }
        if let alignment = style.alignment {
            self.textAlignment = alignment
        }
    }
}
