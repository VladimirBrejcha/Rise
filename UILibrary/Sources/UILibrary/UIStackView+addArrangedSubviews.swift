import UIKit.UIStackView

public extension UIStackView {

    @discardableResult
    func addArrangedSubviews(
        _ subviews: UIView...,
        separated: Bool = false
    ) -> Self {
        addArrangedSubviews(
            subviews,
            separated: separated
        )
    }

    @discardableResult
    func addArrangedSubviews(
        _ subviews: [UIView],
        separated: Bool = false
    ) -> Self {
        subviews.forEach { addArrangedSubview($0) }
        if separated {
            addSeparators(color: Asset.Colors.whiteSeparator.color)
        }
        return self
    }
}
