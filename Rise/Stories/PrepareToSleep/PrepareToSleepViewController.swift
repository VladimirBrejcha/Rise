//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol PrepareToSleepViewInput: AnyObject {
    func updatePicker(with time: Date)
    func updateWakeUp(with text: String)
    func updateSleepDuration(with text: String)
    func updateToSleep(with text: String)
    func close()
    func presentSleep()
}

protocol PrepareToSleepViewOutput: ViewControllerLifeCycle {
    func pickerValueChanged(_ value: Date)
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
    @IBOutlet private weak var toSleepLabel: UILabel!
    
    private var wakeUpExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        toSleepLabel.text = "You are just in time with the plan!"
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
    
    @IBAction private func wakeUpContainerTouchUp(_ sender: UITapGestureRecognizer) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.wakeUpContainerheightConstraint.constant = self.wakeUpExpanded ? 50 : 200
            self.view.layoutIfNeeded()
        }
        animator.startAnimation()
        wakeUpExpanded.toggle()
    }
    
    @IBAction private func startSleepTouchUp(_ sender: Button) {
        output.startPressed()
    }
    
    @IBAction private func closeTouchup(_ sender: UIButton) {
        output.closePressed()
    }
    
    @IBAction private func pickerValueChanged(_ sender: UIDatePicker) {
        output.pickerValueChanged(sender.date)
    }
    
    // MARK: - PrepareToSleepViewInput -
    func updatePicker(with time: Date) {
        wakeUpDatePicker.setDate(time, animated: true)
    }
    
    func updateWakeUp(with text: String) {
        wakeUpTitleLabel.text = text
    }
    
    func updateSleepDuration(with text: String) {
        timeForSleepLabel.text = text
    }
    
    func updateToSleep(with text: String) {
        toSleepLabel.text = text
    }
    
    func close() {
        self.dismiss(animated: true)
    }
    
    func presentSleep() {
        Presenter.present(controller: Story.sleep.configure(), with: .overContext, presentingController: self.presentingViewController!)
    }
    
    // MARK: - Private -
    private func animate(reversed: Bool = false) {
        DispatchQueue.main.async {
            let animator = UIViewPropertyAnimator(duration: 2, curve: .easeInOut)
            animator.addAnimations {
                self.startSleepButton.transform = CGAffineTransform(translationX: 0, y: reversed ? -4 : 0) // todo bugged
            }
            animator.addCompletion { _ in
                self.animate(reversed: !reversed)
            }
            animator.startAnimation()
        }
    }
}
