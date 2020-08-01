//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol SleepViewInput: AnyObject {
    func setAlarmTime(_ text: String)
    func dismiss()
}

protocol SleepViewOutput: ViewControllerLifeCycle {
    func stopPressed()
    var currentTime: String { get }
    var timeLeft: String { get }
}

final class SleepViewController: UIViewController, SleepViewInput {
    var output: SleepViewOutput!
    
    @IBOutlet private weak var currentTimeLabel: AutoRefreshableLabel!
    @IBOutlet private weak var stopButton: LongPressProgressButton!
    @IBOutlet private weak var alarmLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: FloatingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)

        stopButton.title = "Stop"
        stopButton.progressCompleted = { [weak self] _ in self?.output.stopPressed() }
        currentTimeLabel.dataSource = { [weak self] in self?.output.currentTime ?? "" }
        timeLeftLabel.dataSource = { [weak self] in FloatingLabel.Model(text: self?.output.timeLeft ?? "", alpha: 1) }
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDisappear()
    }
    
    // MARK: - SleepViewInput -
    func setAlarmTime(_ text: String) {
        alarmLabel.text = text
    }
    
    func setButtonTitle(_ text: String) {
        
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
}
