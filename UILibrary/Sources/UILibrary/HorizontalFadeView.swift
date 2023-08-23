import UIKit

@objc(HorizontalFadeView)
public final class HorizontalFadeView: UIView {
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.apply(
            Gradient(
                position: (
                    start: CGPoint(x: 0, y: 0),
                    end: CGPoint(x: 1, y: 0)
                ),
                colors: Asset.Colors.white.color
                    .colorsUsingAlpha(0, 0.2, 0.2, 0)
                    .map(\.cgColor)
            )
        )
        self.layer.addSublayer(layer)
        return layer
    }()

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}

fileprivate extension UIColor {
    func colorsUsingAlpha(_ alpha: CGFloat...) -> [UIColor] {
        alpha.map(withAlphaComponent)
    }
}
