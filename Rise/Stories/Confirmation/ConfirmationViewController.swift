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
    
    func showDatePicker(_ show: Bool)
    
    func dismiss()
}

protocol ConfirmationViewOutput: ViewOutput {
    func reshedulePressed()
    func confirmPressed()
}

final class ConfirmationViewController: UIViewController, ConfirmationViewInput {
    var output: ConfirmationViewOutput!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
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
        descriptionLabel.text = text
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    func showDatePicker(_ show: Bool) {
        UIView.animate(withDuration: 0.06, animations: {
            self.datePicker.alpha = show ? 1 : 0
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.datePickerHeightConstraint.constant = show ? 200 : 0
                self.view.layoutIfNeeded()
            }
        }
    }
}
