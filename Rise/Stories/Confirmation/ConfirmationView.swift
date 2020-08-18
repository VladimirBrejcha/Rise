//
//  ConfirmationView.swift
//  Rise
//
//  Created by Владимир Королев on 03.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

final class ConfirmationView: UIView, PropertyAnimatable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var buttonsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var resheduleButton: Button!
    @IBOutlet private weak var confirmButton: Button!
    @IBOutlet private weak var loadingView: LoadingView!
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    struct Handlers {
        let resheduleTouch: () -> Void
        let confirmTouch: () -> Void
    }
    var handlers: Handlers?
    
    struct Model {
        let title: String
        let description: String
    }
    var model: Model = Model(title: "", description: "") {
        didSet {
            titleLabel.text = model.title
            UIView.transition(with: descriptionLabel, duration: 0.36,
                              options: .transitionCrossDissolve,
                              animations: { self.descriptionLabel.text = self.model.description },
                              completion: nil)
        }
    }
    
    struct State {
        let loadingViewHidden: Bool
        let resheduleButtonHidden: Bool
    }
    var state: State = State(loadingViewHidden: true, resheduleButtonHidden: true) {
        didSet {
            animate {
                self.resheduleButton.isHidden = self.state.resheduleButtonHidden
                self.loadingView.state = self.state.loadingViewHidden ? .hidden : .loading
                self.buttonsStackView.alpha = self.state.loadingViewHidden ? 1 : 0
            }
        }
    }
    
    func configure(model: Model, handlers: Handlers) {
        self.model = model
        self.handlers = handlers
    }
    
    @IBAction private func resheduleTouchUp(_ sender: Button) {
        handlers?.resheduleTouch()
    }
    
    @IBAction private func confirmTouchUp(_ sender: Button) {
        handlers?.confirmTouch()
    }
}
