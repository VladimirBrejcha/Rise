import UIKit.UIStackView

public extension UIStackView {

    func addSeparators(color: UIColor) {
        var i = arrangedSubviews.count - 1
        while i > 0 {
            let separator = createSeparator(color: color)
            insertArrangedSubview(separator, at: i)
            i -= 1
        }
    }

    private
    func createSeparator(color: UIColor) -> UIView {
        let separator = UIView()
        separator.activateConstraints { s in
            [{
                if axis == .vertical {
                    return s.heightAnchor.constraint(equalToConstant: 1)
                } else {
                    return s.widthAnchor.constraint(equalToConstant: 1)
                }
            }()]
        }
        separator.backgroundColor = color
        return separator
    }
}
