import UIKit

extension UISegmentedControl: Styleable {
    public func applyStyle(_ style: Style.SegmentedControl) {
        selectedSegmentTintColor = style.selectionColor
        backgroundColor = style.backgroundColor
        setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: style.normalTextColor],
            for: .normal
        )
        setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: style.selectedTextColor],
            for: .selected
        )
    }
}
