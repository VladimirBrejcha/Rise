//
//  LoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum LoadingViewState: Equatable {
    case content
    case loading
    case info (message: String)
    case error (message: String)
}

@IBDesignable
final class LoadingView: UIButton, NibLoadable {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var errorContainerView: UIView!
    @IBOutlet private weak var repeatButton: Button!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet var containerView: DesignableContainerView!
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }()
    
    private var loadingAnimation: Animation?
    private var viewState: LoadingViewState = .content
    
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
    
    func changeState(to state: LoadingViewState) {
        if viewState == state {
            log(.info, with: "changeState cancelled, because view is in the same state already")
            return
        }
        
        crossDisolve(from: chooseView(for: viewState), to: prepareView(for: state))
        self.viewState = state
    }
    
    
    // MARK: - Private -
    private func prepareView(for state: LoadingViewState) -> UIView {
        switch state {
        case .content:
            return contentView
        case .error(let error):
            errorLabel.text = error
            return errorContainerView
        case .info(let info):
            infoLabel.text = info
            return infoLabel
        case .loading:
            loadingAnimation = PulsingCircleAnimation(with: animationView.layer)
            loadingAnimation?.animate(true)
            return animationView
        }
    }
    
    private func chooseView(for state: LoadingViewState) -> UIView {
        switch state {
        case .content:
            return contentView //todo crash because of nil
        case .error:
            return errorContainerView
        case .info:
            return infoLabel
        case .loading:
            return animationView
        }
    }
    
    private func crossDisolve(from oldView: UIView, to newView: UIView) {
        if animator.state != .inactive {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .end)
        }
        
        animator.addAnimations {
            oldView.alpha = 0
            newView.alpha = 1
        }
        
        animator.startAnimation()
    }
}

