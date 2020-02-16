//
//  VerticalPositionMoveAnimation.swift
//  Rise
//
//  Created by Владимир Королев on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class VerticalPositionMoveAnimation: Animation {
    private let animationLayer: CALayer
    private var animationKey: String {
        String(describing: Self.self)
    }
    private let from: CGFloat
    private let to: CGFloat
    private let duration: CFTimeInterval
    
    init(with layer: CALayer,
         from: CGFloat = 0,
         to: CGFloat = 0,
         duration: CFTimeInterval = 1
    ) {
        self.from = from
        self.to = to
        self.duration = duration
        self.animationLayer = layer
    }
    
    deinit {
        animationLayer.sublayers = nil
        animationLayer.removeAllAnimations()
    }
    
    func animate(_ animate: Bool) {
        if animate {
            animationLayer.add(makeBasicAnimation(), forKey: animationKey)
        }
        animationLayer.isHidden = !animate
        animationLayer.speed = animate ? 1 : 0
    }
    
    private func makeBasicAnimation() -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: AnimationKeys.positionY)
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fromValue = animationLayer.frame.midY + from
        basicAnimation.toValue = animationLayer.frame.midY + to
        basicAnimation.duration = duration
        basicAnimation.autoreverses = true
        basicAnimation.repeatCount = Float.greatestFiniteMagnitude
        return basicAnimation
    }
}
