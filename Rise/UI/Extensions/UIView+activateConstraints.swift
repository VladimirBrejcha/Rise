import UIKit

extension UIView {
    func activateConstraints(_ constraints: NSLayoutConstraint...) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}
