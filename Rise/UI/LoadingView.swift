//
//  LoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingView: UIButton, NibLoadable {

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
        
    }
    
    func showLoadingError() {
        toggleViewAppearance(show: true, errorContainerView)
    }
    
    func hideError() {
        toggleViewAppearance(show: false, errorContainerView)
    }
    
    func showLoading() {
        animationManager?.startAnimating()
        toggleViewAppearance(show: true, animationView)
    }
    
    func hideLoading(completion: @escaping () -> Void) {
        hideSelf {
            self.animationManager?.stopAnimating()
            completion()
        }
    }
    
    func showInfo(with text: String) {
        infoLabel.text = text
        toggleViewAppearance(show: true, infoLabel)
    }
    
    func hideInfo() { toggleViewAppearance(show: false, infoLabel) }
    
    func hideSelf(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0
        }) { _ in  completion() }
    }
    
    // MARK: - Private
    private func toggleViewAppearance(show: Bool, _ view: UIView) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: { view.alpha = show ? 1 : 0 })
    }
}
