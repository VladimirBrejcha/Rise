import UIKit

extension CAGradientLayer: Gradientable {
    public func apply(_ gradient: Gradient) {
        startPoint = gradient.position.start
        endPoint = gradient.position.end
        colors = gradient.colors
    }
}
