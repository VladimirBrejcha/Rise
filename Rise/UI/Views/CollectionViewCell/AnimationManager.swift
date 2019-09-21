//
//  AnimationManager.swift
//  Rise
//
//  Created by Владимир Королев on 21/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class AnimationManager {
    private let scaleKeyPath = "transform.scale"
    private let opacityKeyPath = "opacity"
    private let animationKey = "animation"
    
    private let animationLayer: CALayer
    private let animationTintColor: UIColor
    private let defaultSize = 40.0
    
    init(layer: CALayer, tintColor: UIColor) {
        self.animationLayer = layer
        self.animationTintColor = tintColor
    }
    
    // MARK: - control animations
    func startAnimating() {
        animationLayer.isHidden = false
        animationLayer.speed = 1
    }
    
    func stopAnimating() {
        animationLayer.speed = 0
        animationLayer.isHidden = true
    }
    
    // MARK: - setup
    func setupAnimation() {
        animationLayer.sublayers = nil
        animationLayer.speed = 0
        animationLayer.isHidden = true
        setupAnimation(layer: animationLayer, size: CGSize(width: defaultSize, height: defaultSize), tintColor: animationTintColor)
    }
    
    private func setupAnimation(layer: CALayer, size: CGSize, tintColor: UIColor) {
        let duration = 1.0
        let beginTimes = [0, 0.2, 0.4]
        
        // Scale animation
        let scaleAnimation = createBasicAnimation(keyPath: scaleKeyPath)
        scaleAnimation.duration = duration
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        
        // Opacity animation
        let opacityAnimation = createKeyFrameAnimation(keyPath: opacityKeyPath)
        opacityAnimation.duration = duration
        opacityAnimation.keyTimes = [0, 0.05, 1]
        opacityAnimation.values = [0, 1, 0]
        
        // Animation
        let animation = createAnimationGroup()
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        for i in 0...2 {
            let circle = CAShapeLayer()
            let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                          cornerRadius: size.width / 2)
            animation.beginTime = beginTimes[i]
            circle.fillColor = tintColor.cgColor
            circle.path = circlePath.cgPath
            circle.opacity = 0
            circle.add(animation, forKey: animationKey)
            circle.frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                                  y: (layer.bounds.size.height - size.height) / 2,
                                  width: size.width, height: size.height)
            layer.addSublayer(circle)
        }
    }
    
    // MARK: - create animations
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
