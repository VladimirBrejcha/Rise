//
//  LoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol LoadingViewDelegate: AnyObject {
    func repeatButtonPressed()
}

@IBDesignable
class LoadingView: UIButton, NibLoadable {
    weak var delegate: LoadingViewDelegate?

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var errorContainerView: UIView!
    @IBOutlet weak var errorButton: Button!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var animationView: UIView!
    
    private var animationManager: AnimationManager?
    private let animationLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    func setupAnimationLayer() { // call it from outside once view layout been set to correctly setup animation
        animationView.layer.sublayers = nil
        animationLayer.frame = animationView.bounds
        animationView.layer.addSublayer(animationLayer)
        animationManager = AnimationManager(layer: animationLayer, tintColor: .white)
        animationManager?.setupAnimation()
        setNeedsDisplay()
    }

    @IBAction func errorButtonPressed(_ sender: Button) {
        delegate?.repeatButtonPressed()
    }
    
    // MARK: - Error
    func showLoadingError() {
        toggleViewAppearance(show: true, errorContainerView)
    }
    
    func hideError() {
        toggleViewAppearance(show: false, errorContainerView)
    }
    
    // MARK: - Loadiing
    func showLoading(completion: (() -> Void)? = nil) {
        animationManager?.startAnimating()
        toggleViewAppearance(show: true, animationView, completion: completion)
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        toggleViewAppearance(show: false, animationView) {
            self.animationManager?.stopAnimating()
            completion?()
        }
    }
    
    // MARK: - Info
    func showInfo(with text: String) {
        infoLabel.text = text
        toggleViewAppearance(show: true, infoLabel)
    }
    
    func hideInfo(completion: (() -> Void)? = nil) {
        toggleViewAppearance(show: false, infoLabel, completion: completion)
    }
    
    // MARK: - Private
    private func hideSelf(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0
        }) { _ in  completion() }
    }
    
    private func toggleViewAppearance(show: Bool, _ view: UIView, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            view.alpha = show ? 1 : 0
        }) { _ in completion?() }
    }
}
