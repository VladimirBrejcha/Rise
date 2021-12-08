//
//  ScrollTransition.swift
//  Rise
//
//  Created by Vladimir Korolev on 30/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScrollTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let viewControllers: [UIViewController]?

    private let backgroundView: UIView
    private let backgroundTranslationX: CGFloat

    private let transitionDuration: Double = 0.2
    
    init(
        viewControllers: [UIViewController]?,
        backgroundView: UIView,
        backgroundTranslationX: CGFloat
    ) {
        self.viewControllers = viewControllers
        self.backgroundView = backgroundView
        self.backgroundTranslationX = backgroundTranslationX
    }
    
    private func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        transitionDuration
    }

    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        let bgTransform: CGAffineTransform = {
            switch toIndex {
            case 0:
                return .init(translationX: backgroundTranslationX, y: 0)
            case 2:
                return .init(translationX: -backgroundTranslationX, y: 0)
            default:
                return .identity
            }
        }()

        transitionContext.containerView.addSubview(toView)

        UIView.animate(
            withDuration: transitionDuration * 2,
            delay: 0,
            options: [.curveEaseOut]
        ) { [self] in
            backgroundView.transform = bgTransform
        } completion: { success in
            transitionContext.completeTransition(success)
        }

        UIView.animate(
            withDuration: transitionDuration
        ) {
            fromView.frame = fromFrameEnd
            toView.frame = frame
        } completion: { _ in
            fromView.removeFromSuperview()
        }
    }
}
