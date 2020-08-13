//
//  CreatePlanView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CreatePlanView:
    UIView,
    BackgroundSettable,
    PropertyAnimatable
{
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var backButton: Button!
    @IBOutlet private weak var nextButton: Button!
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    struct State {
        let nextButtonEnabled: Bool
        let backButtonHidden: Bool
    }
    var state: State? {
        didSet {
            if let state = state {
                animate {
                    self.backButton.isHidden = state.backButtonHidden
                }
                nextButton.isEnabled = state.nextButtonEnabled
            }
        }
    }
    
    struct Model {
        let backButtonTitle: String
        let nextButtonTitle: String
        let closeHandler: () -> Void
        let backHandler: () -> Void
        let nextHandler: () -> Void
    }
    var model: Model? {
        didSet {
            if let model = model {
                backButton.setTitle(model.backButtonTitle, for: .normal)
                nextButton.setTitle(model.nextButtonTitle, for: .normal)
            }
        }
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        model?.closeHandler()
    }
    
    @IBAction private func backTouchUp(_ sender: Button) {
        model?.backHandler()
    }
    
    @IBAction private func nextTouchUp(_ sender: Button) {
        model?.nextHandler()
    }
}

extension CreatePlanView.Model: Changeable {
    init(copy: ChangeableWrapper<CreatePlanView.Model>) {
        self.init(
            backButtonTitle: copy.backButtonTitle,
            nextButtonTitle: copy.nextButtonTitle,
            closeHandler: copy.closeHandler,
            backHandler: copy.backHandler,
            nextHandler: copy.nextHandler
        )
    }
}

extension CreatePlanView.State: Changeable {
    init(copy: ChangeableWrapper<CreatePlanView.State>) {
        self.init(
            nextButtonEnabled: copy.nextButtonEnabled,
            backButtonHidden: copy.backButtonHidden
        )
    }
}
