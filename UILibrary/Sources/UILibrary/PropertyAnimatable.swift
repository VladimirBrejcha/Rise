import UIKit

public protocol PropertyAnimatable {
    var propertyAnimationDuration: Double { get }
}

public extension PropertyAnimatable {
    func animate(_ animation: @escaping () -> Void) {
        UIViewPropertyAnimator(
            duration: propertyAnimationDuration,
            curve: .easeInOut,
            animations: animation
        ).startAnimation()
    }
}
