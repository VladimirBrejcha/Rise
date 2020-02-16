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
    
    private var loadingAnimation: Animation?
    
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
        loadingAnimation = PulsingCircleAnimation(with: animationView.layer)
        
        if show {
            loadingAnimation?.animate(true)
            showView(true, view: animationView, completion: completion)
        } else {
            showView(false, view: animationView) {
                self.loadingAnimation?.animate(false)
                completion?()
            }
        }
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
