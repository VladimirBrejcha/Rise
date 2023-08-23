import UIKit

public extension UIView {
    func applyBlur(style: UIBlurEffect.Style) {
        let blur = UIBlurEffect(style: style)
        let view = UIVisualEffectView(effect: blur)
        view.layer.masksToBounds = true
        addSubview(view)
        sendSubviewToBack(view)
        view.activateConstraints(edgesTo(self))
    }
}
