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
    private let animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(animationView)
        animationView.frame = bounds
        animationManager = AnimationManager(layer: animationView.layer, tintColor: .white)
        animationManager?.setupAnimation()
    }
    
    func showLoading() {
        animationManager?.startAnimating()
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.animationView.alpha = 1
        })
    }
    
    func hideLoading(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.animationView.alpha = 0
        }) { _ in
            self.animationManager?.stopAnimating()
            completion()
        }
    }
}
