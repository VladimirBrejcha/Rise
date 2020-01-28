//
//  AnimationManager.swift
//  Rise
//
//  Created by Владимир Королев on 21/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum AnimationType {
    case pulsingCircles
}

final class AnimationManager {
    private let scaleKeyPath = "transform.scale"
    private let opacityKeyPath = "opacity"
    private let animationKey = "animation"
    
    var animationLayer: CALayer?
    var animationTintColor: UIColor = .white
    var animationSize = CGSize(width: 40.0, height: 40.0)
    
    private let type: AnimationType
    
    init(with type: AnimationType) {
        self.type = type
    }
    
    func animate(_ animated: Bool) {
        animationLayer?.isHidden = !animated
        animationLayer?.speed = animated ? 1 : 0
    }
    
    func setupAnimation(on layer: CALayer) {
        self.animationLayer = layer
        animationLayer?.sublayers = nil
        
        switch type {
        case .pulsingCircles:
            let duration = 1.0
            let beginTimes = [0, 0.2, 0.4]
            
            let scaleAnimation = createBasicAnimation(keyPath: scaleKeyPath)
            scaleAnimation.duration = duration
            scaleAnimation.fromValue = 0
            scaleAnimation.toValue = 1
            
            let opacityAnimation = createKeyFrameAnimation(keyPath: opacityKeyPath)
            opacityAnimation.duration = duration
            opacityAnimation.keyTimes = [0, 0.05, 1]
            opacityAnimation.values = [0, 1, 0]
            
            let animation = createAnimationGroup()
            animation.animations = [scaleAnimation, opacityAnimation]
            animation.duration = duration
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            
            for i in 0...2 {
                let circle = CAShapeLayer()
                let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0,
                                                                  width: animationSize.width,
                                                                  height: animationSize.height),
                                              cornerRadius: animationSize.width / 2)
                animation.beginTime = beginTimes[i]
                circle.fillColor = animationTintColor.cgColor
                circle.path = circlePath.cgPath
                circle.opacity = 0
                circle.add(animation, forKey: animationKey)
                circle.frame = CGRect(x: (layer.frame.size.width - animationSize.width) / 2,
                                      y: (layer.frame.size.height - animationSize.height) / 2,
                                      width: animationSize.width,
                                      height: animationSize.height)
                layer.addSublayer(circle)
            }
        }
    }
    
    // MARK: - Private -
    private func createBasicAnimation(keyPath: String) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func createKeyFrameAnimation(keyPath: String) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func createAnimationGroup() -> CAAnimationGroup {
        let animationGroup = CAAnimationGroup()
        animationGroup.isRemovedOnCompletion = false
        return animationGroup
    }
}
