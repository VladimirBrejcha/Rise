import UIKit

extension UIView {
    @discardableResult func addSubviews(_ subviews: UIView...) -> Self {
        subviews.forEach { addSubview($0) }
        return self
    }
}
