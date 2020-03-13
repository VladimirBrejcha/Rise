//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol PrepareToSleepViewInput: AnyObject {
    func close()
}

protocol PrepareToSleepViewOutput: ViewControllerLifeCycle {
    func startPressed()
    func closePressed()
}

final class PrepareToSleepViewController: UIViewController, PrepareToSleepViewInput {
    var output: PrepareToSleepViewOutput!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var startSleepButton: Button!
    @IBOutlet private weak var startSleepLabel: UILabel!
    @IBOutlet private weak var wakeUpContainerheightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var wakeUpTitleLabel: UILabel!
    @IBOutlet private weak var wakeUpDatePicker: UIDatePicker!
    @IBOutlet private weak var timeForSleepLabel: UILabel!
    @IBOutlet private weak var wentSleepLabel: UILabel!
    
    private var wakeUpExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        wentSleepLabel.text = "You are just in time with the plan!"
        wakeUpTitleLabel.text = "Alarm at 06:00"
        titleLabel.text = "Prepare to sleep"
        timeForSleepLabel.text = "8 hours 30 minutes until wake up"
        startSleepLabel.text = "begin to sleep"
        startSleepButton.layer.cornerRadius = 0
        startSleepButton.backgroundColor = .clear
        startSleepButton.alpha = 0.9
        
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animate()
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
    
    @IBAction func wakeUpContainerTouchUp(_ sender: UITapGestureRecognizer) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.wakeUpContainerheightConstraint.constant = self.wakeUpExpanded ? 50 : 200
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        wakeUpExpanded.toggle()
    }
    
    @IBAction func startSleepTouchUp(_ sender: Button) {
        output.startPressed()
    }
    
    @IBAction func closeTouchup(_ sender: UIButton) {
        output.closePressed()
    }
    
    private func animate(reversed: Bool = false) {
        let animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut)
        animator.addAnimations {
            self.startSleepButton.transform = CGAffineTransform(translationX: 0, y: reversed ? -4 : 0) // todo bugged
        }
        animator.addCompletion { _ in
            self.animate(reversed: !reversed)
        }
        animator.startAnimation()
    }
    
    // MARK: - PrepareToSleepViewInput -
    func close() {
        self.dismiss(animated: true)
    }
}
