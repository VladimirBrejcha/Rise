import UIKit
import Core

public final class FloatingLabel: UILabel, AutoRefreshable, PropertyAnimatable {

    private let animation = VerticalPositionMoveAnimation()
    public var propertyAnimationDuration: Double = 1
    private var needsConfiguration: Bool = true

    public override func layoutSubviews() {
        super.layoutSubviews()
        if needsConfiguration {
            animation.add(to: layer)
            needsConfiguration = false
        }
    }

    public func restartAnimation() {
        animation.removeFromSuperlayer()
        animation.add(to: layer)
    }

    deinit {
        animation.removeFromSuperlayer()
        stopRefreshing()
    }

    // MARK: - AutoRefreshable

    public var timer: Timer?
    public var refreshInterval: Double = 2
    public var dataSource: (() -> Model)?

    public struct Model {
        public init(text: String, alpha: Float) {
            self.text = text
            self.alpha = alpha
        }

        let text: String
        let alpha: Float
    }
    
    public func refresh(with data: Model) {
        text = data.text
        animate {
            self.alpha = CGFloat(data.alpha)
        }
    }
}
