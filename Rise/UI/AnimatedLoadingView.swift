//
//  AnimatedLoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 05/10/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class AnimatedLoadingView: DesignableContainerView {
    private var animationManager: AnimationManager?
    private let animationLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    
    
    func setupAnimationLayer() {
        layer.sublayers = nil
        animationLayer.frame = bounds
        layer.addSublayer(animationLayer)
        animationManager = AnimationManager(layer: animationLayer, tintColor: .white)
        animationManager?.setupAnimation()
        setNeedsDisplay()
    }
    
    func showLoading() {
        animationManager?.startAnimating()
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 1
        })
    }
    
    func hideLoading(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0
        }) { _ in
            self.animationManager?.stopAnimating()
            completion()
        }
    }
}
