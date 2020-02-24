//
//  ConfirmationViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol ConfirmationViewInput: AnyObject {
    func updateTitle(with text: String)
    func updateDescription(with text: String)

    func showButtons(_ show: Bool)
    func showRescheduleButton(_ show: Bool)
    func updateConfirmButtonTitle(with text: String)
    func showLoadingView(_ show: Bool)
    
    func dismiss()
}

protocol ConfirmationViewOutput: ViewOutput {
    func reshedulePressed()
    func confirmPressed()
}

final class ConfirmationViewController: UIViewController, ConfirmationViewInput {
    var output: ConfirmationViewOutput!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var buttonsStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var resheduleButton: Button!
    @IBOutlet private weak var confirmButton: Button!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var loadingViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.containerView.background = .clear
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    @IBAction func resheduleTouchUp(_ sender: Button) {
        output.reshedulePressed()
    }
    
    @IBAction func confirmTouchUp(_ sender: Button) {
        output.confirmPressed()
    }
    
    // MARK: - ConfirmationViewInput -
    func updateTitle(with text: String) {
        titleLabel.text = text
    }
    
    func updateDescription(with text: String) {
        UIView.transition(with: descriptionLabel, duration: 0.36,
                          options: .transitionCrossDissolve,
                          animations:
            { self.descriptionLabel.text = text },
                          completion: nil)
    }
    
    func showButtons(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.buttonsStackView.isHidden = !show
            self.buttonsStackViewHeightConstraint.constant = show ? 50 : 0
        }
    }
    
    func showRescheduleButton(_ show: Bool) {
        resheduleButton.isHidden = !show
    }
    
    func updateConfirmButtonTitle(with text: String) {
        confirmButton.setTitle(text, for: .normal)
    }
        
    func showLoadingView(_ show: Bool) {
        UIView.animate(withDuration: 0.06, animations: {
            self.loadingView.alpha = show ? 1 : 0
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.loadingViewHeightConstraint.constant = show ? 100 : 0
                self.view.layoutIfNeeded()
                self.loadingView.changeState(to: .loading)
            }
        }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
