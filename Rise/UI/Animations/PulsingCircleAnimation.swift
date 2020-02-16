//
//  PulsingCircleAnimation.swift
//  Rise
//
//  Created by Владимир Королев on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PulsingCircleAnimation: Animation {
    private weak var animationLayer: CALayer?
    private var animationKey: String {
        String(describing: Self.self)
    }
    private let animationSize = CGSize(width: 40.0, height: 40.0)
    private let animationTintColor: UIColor = .white
    private let from: CGFloat
    private let to: CGFloat
    private let duration: CFTimeInterval
    private var setupNeeded: Bool = true
    
    init(with layer: CALayer,
         from: CGFloat = 0,
         to: CGFloat = 1,
         duration: CFTimeInterval = 1
    ) {
        self.from = from
        self.to = to
        self.duration = duration
        self.animationLayer = layer
    }
    
    deinit {
        animationLayer?.sublayers = nil
        animationLayer?.removeAllAnimations()
    }
    
    func animate(_ animate: Bool) {
        guard let layer = animationLayer else { return }
        if animate && setupNeeded {
            setupAnimation()
            setupNeeded = false
        }
        layer.isHidden = !animate
        layer.speed = animate ? 1 : 0
    }
    
    private func setupAnimation() {
        let scaleAnimation = CABasicAnimation(keyPath: AnimationKeys.scale)
        scaleAnimation.fromValue = from
        scaleAnimation.toValue = to
        scaleAnimation.duration = duration
        scaleAnimation.isRemovedOnCompletion = false
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.opacity)
        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let beginTimes = [0, 0.2, 0.4]
        for i in 0...2 {
            let circle = CAShapeLayer()
            let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                              width: animationSize.width,
                                                              height: animationSize.height),
                                          cornerRadius: animationSize.width / 2)
            animationGroup.beginTime = beginTimes[i]
            circle.fillColor = animationTintColor.cgColor
            circle.path = circlePath.cgPath
            circle.opacity = 0
            circle.add(animationGroup, forKey: animationKey)
            circle.frame = CGRect(x: (animationLayer!.frame.size.width - animationSize.width) / 2,
                                  y: (animationLayer!.frame.size.height - animationSize.height) / 2,
                                  width: animationSize.width,
                                  height: animationSize.height)
            animationLayer?.addSublayer(circle)
        }
    }
}
