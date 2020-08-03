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
    
    var propertyAnimationDuration: Double = 0.3
    var resheduleHandler: (() -> Void)?
    var confirmHandler: (() -> Void)?
    
    var titleText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var descriptionText: String? {
        get { descriptionLabel.text }
        set { UIView.transition(with: descriptionLabel, duration: 0.36,
                                options: .transitionCrossDissolve,
                                animations: { self.descriptionLabel.text = newValue },
                                completion: nil)
        }
    }
    
    @IBAction private func resheduleTouchUp(_ sender: Button) {
        resheduleHandler?()
    }
    
    @IBAction private func confirmTouchUp(_ sender: Button) {
        confirmHandler?()
    }
    
    func showRescheduleButton(_ show: Bool) {
        resheduleButton.isHidden = !show
    }
    
    func updateConfirmButtonTitle(with text: String) {
        confirmButton.setTitle(text, for: .normal)
    }
    
    func showLoadingView(_ show: Bool) {
        animate {
            self.loadingView.state = show ? .loading : .hidden
            self.buttonsStackView.alpha = show ? 0 : 1
        }
    }
}
