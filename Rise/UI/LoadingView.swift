//
//  LoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
final class LoadingView: UIButton, NibLoadable {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var errorContainerView: UIView!
    @IBOutlet private weak var repeatButton: Button!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet var containerView: DesignableContainerView!
    
    private var animationManager: AnimationManager?
    private var animationLayer: CALayer?
    
    var repeatButtonHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    @IBAction func errorButtonPressed(_ sender: Button) {
        repeatButtonHandler?()
    }
    
    // MARK: - Error view -
    func showError(_ show: Bool) {
        showView(show, view: errorContainerView)
    }
    
    // MARK: - Loadiing animation -
    func showLoading(_ show: Bool, completion: (() -> Void)? = nil) {
        if animationLayer == nil {
            setupAnimationLayer()
        }
        
        if show {
            animationManager?.animate(true)
            showView(true, view: animationView, completion: completion)
        } else {
            showView(false, view: animationView) {
                 self.animationManager?.animate(false)
                 completion?()
             }
        }
    }
    
    private func setupAnimationLayer() {
        animationView.layer.sublayers = nil
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        layer.frame = animationView.bounds
        animationView.layer.addSublayer(layer)
        
        self.animationLayer = layer
        animationManager = AnimationManager(with: .pulsingCircles)
        animationManager?.setupAnimation(on: layer)
        setNeedsDisplay()
    }
    
    // MARK: - Info label -
    func showInfo(with text: String) {
        infoLabel.text = text
        showView(true, view: infoLabel)
    }
    
    func hideInfo(completion: (() -> Void)? = nil) {
        showView(false, view: infoLabel, completion: completion)
    }
    
    // MARK: - Private -
    private func showView(_ show: Bool, view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            view.alpha = show ? 1 : 0
        }) { _ in completion?() }
    }
}
