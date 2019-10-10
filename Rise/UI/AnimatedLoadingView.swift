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
    
    private var button: Button!
    private var label: UILabel!
    
    func setupLabel() {
        let width = bounds.width / 2
        let height = bounds.height / 3
        let x = (bounds.width / 2) - (width / 2)
        let y = (bounds.height / 2) - (height * 1.2)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = "loading failed"
        label.alpha = 0
        addSubview(label)
    }
    
    func showLabel(_ show: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.label.alpha = show ? 1 : 0
         })
    }
    
    func setupButton() {
        let width = bounds.width / 3
        let height = bounds.height / 3
        let x = (bounds.width / 2) - (width / 2)
        let y = (bounds.height / 2) - (height / 5)
        let frame = CGRect(x: x, y: y, width: width, height: height)
        button = Button(frame: frame)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("try again", for: .normal)
        button.alpha = 0
        addSubview(button)
    }
    
    func showButton(_ show: Bool) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.button.alpha = show ? 1 : 0
         })
    }
    
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
