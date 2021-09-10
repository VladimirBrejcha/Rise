//
//  CreatePlanView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CreatePlanView: UIView, PropertyAnimatable {
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var backButton: Button!
    @IBOutlet private weak var nextButton: Button!
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    struct State: Equatable {
        let nextButtonEnabled: Bool
        let backButtonHidden: Bool
    }
    var state: State = State(nextButtonEnabled: true, backButtonHidden: true) {
        didSet {
            if state.nextButtonEnabled != oldValue.nextButtonEnabled {
                nextButton.isEnabled = state.nextButtonEnabled
            }
            if state.backButtonHidden != oldValue.backButtonHidden {
                animate {
                    self.backButton.isHidden = self.state.backButtonHidden
                }
            }
        }
    }
    
    struct Model {
        let backButtonTitle: String
        let nextButtonTitle: String
    }
    var model: Model? {
        didSet {
            if let model = model {
                backButton.setTitle(model.backButtonTitle, for: .normal)
                nextButton.setTitle(model.nextButtonTitle, for: .normal)
            }
        }
    }
    
    struct Handlers {
        let close: () -> Void
        let back: () -> Void
        let next: () -> Void
    }
    var handlers: Handlers?
    
    func configure(model: Model, handlers: Handlers) {
        self.backButton.applyStyle(.secondary)
        self.backButton.isHidden = true
        self.model = model
        self.handlers = handlers
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        handlers?.close()
    }
    
    @IBAction private func backTouchUp(_ sender: Button) {
        handlers?.back()
    }
    
    @IBAction private func nextTouchUp(_ sender: Button) {
        handlers?.next()
    }
}
