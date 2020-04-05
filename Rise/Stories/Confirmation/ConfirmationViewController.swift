//
//  ConfirmationViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

protocol ConfirmationViewInput: AnyObject {
    func updateTitle(with text: String)
    func updateDescription(with text: String)

    func showRescheduleButton(_ show: Bool)
    func updateConfirmButtonTitle(with text: String)
    func showLoadingView(_ show: Bool)
    
    func dismiss()
}

protocol ConfirmationViewOutput: ViewControllerLifeCycle {
    func reshedulePressed()
    func confirmPressed()
}

final class ConfirmationViewController:
    UIViewController,
    ConfirmationViewInput,
    PropertyAnimatable
{
    var propertyAnimationDuration: Double = 0.3
    
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
                          animations: { self.descriptionLabel.text = text },
                          completion: nil)
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
    
    func dismiss() {
        dismiss(animated: true)
    }
}
