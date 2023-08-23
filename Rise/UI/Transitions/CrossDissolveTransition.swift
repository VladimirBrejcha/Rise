//
//  CrossDissolveTransition.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CrossDissolveTransition: NSObject, UIViewControllerAnimatedTransitioning {

    private let transitionDuration = 0.2

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        else {
            return
        }

        transitionContext.containerView.addSubview(toController.view)
        toController.view.alpha = 0

        let animator = UIViewPropertyAnimator(
            duration: transitionDuration,
            curve: .easeIn
        ) {
            toController.view.alpha = 1
        }
        animator.addCompletion { _ in
            transitionContext.completeTransition(true)
        }
        animator.startAnimation()
    }
}
