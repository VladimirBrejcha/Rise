import UIKit

extension UIDatePicker: Styleable {
    public func applyStyle(_ style: Style.Picker) {
        setValue(style.textColor, forKey: "textColor")
        setValue(style.lineColor, forKey: "magnifierLineColor")
    }
}
