import UIKit

extension UITabBarItemAppearance: Styleable {
    public func applyStyle(_ style: UILibrary.Style.TabBar.Item) {
        normal.iconColor = style.iconColor.normal
        selected.iconColor = style.iconColor.selected
    }
}
