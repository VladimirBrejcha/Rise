import UIKit

public extension UIView {
    func addBackgroundView(
        _ bgView: Background = .default,
        blur: UIBlurEffect.Style? = nil
    ) {
        let view = bgView.asUIView
        blur.flatMap(view.applyBlur(style:))
        addSubview(view)
        sendSubviewToBack(view)
        view.clipsToBounds = true
        view.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor),
            $0.topAnchor.constraint(equalTo: topAnchor),
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)]
        }
    }
}
