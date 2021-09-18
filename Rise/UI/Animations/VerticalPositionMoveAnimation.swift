//
//  VerticalPositionMoveAnimation.swift
//  Rise
//
//  Created by Vladimir Korolev on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class VerticalPositionMoveAnimation: Animation {
    private weak var animationLayer: CALayer?
    private var animationKey: String {
        String(describing: Self.self)
    }
    
    func add(to layer: CALayer) {
        animationLayer = layer
        animationLayer?.add(
            makeBasicAnimation(for: layer
            ),
            forKey: animationKey
        )
    }
    
    func removeFromSuperlayer() {
        animationLayer?.removeAnimation(forKey: animationKey)
    }
    
    private func makeBasicAnimation(for layer: CALayer) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: AnimationKeys.positionY)
        basicAnimation.isRemovedOnCompletion = false
        basicAnimation.fromValue = layer.frame.midY + 4
        basicAnimation.toValue = layer.frame.midY + 0
        basicAnimation.duration = 5
        basicAnimation.autoreverses = true
        basicAnimation.repeatCount = Float.greatestFiniteMagnitude
        return basicAnimation
    }
}
