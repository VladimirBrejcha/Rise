//
//  LoadingView.swift
//  Rise
//
//  Created by Владимир Королев on 10.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum LoadingViewState: Equatable {
    case hidden
    case showingLoading
    case showingInfo (info: String)
    case showingError (error: String)
}

@IBDesignable
final class LoadingView: UIButton, NibLoadable {
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var errorContainerView: UIView!
    @IBOutlet private weak var repeatButton: Button!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var animationView: UIView!
    @IBOutlet var containerView: DesignableContainerView!
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }()
    
    private var loadingAnimation: Animation?
    private var viewState: LoadingViewState = .hidden
    
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
    
    // MARK: - Private -
    func show(state: LoadingViewState, completion: (() -> Void)? = nil) {
        if viewState == state { completion?(); return }
        
        show(state: viewState, false) { [weak self] in
            self?.show(state: state, true) { [weak self] in
                self?.viewState = state
                completion?()
            }
        }
    }
    
    private func show(state: LoadingViewState, _ show: Bool, completion: (() -> Void)? = nil) {
        if show == false && state == .hidden { completion?(); return }
        
        if show {
            switch state {
            case .showingLoading:
                loadingAnimation = PulsingCircleAnimation(with: animationView.layer)
                loadingAnimation?.animate(true)
            case .showingInfo(let info):
                infoLabel.text = info
            case .showingError(let error):
                errorLabel.text = error
            default:
                break
            }
        }
        
        showView(show, view: chooseView(for: state), completion: completion)
    }
    
    private func chooseView(for state: LoadingViewState) -> UIView {
        switch state {
        case .hidden:
            return self
        case .showingError:
            return errorContainerView
        case .showingInfo:
            return infoLabel
        case .showingLoading:
            return animationView
        }
    }
    
    private func showView(_ show: Bool, view: UIView, completion: (() -> Void)? = nil) {
        if animator.isRunning {
            animator.stopAnimation(false)
            animator.finishAnimation(at: .end)
        }
        animator.addAnimations {
            view.alpha = show ? 1 : 0
        }
        animator.startAnimation()
        completion?()
    }
}

