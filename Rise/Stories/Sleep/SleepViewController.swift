//
//  SleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepViewController: UIViewController {
    @IBOutlet private var sleepView: SleepView!
    
    var alarmTime: Date! // DI
    
    private var currentTime: String { Date().HHmmString }
    private var timeLeft: String { "Time left \(alarmTime.timeIntervalSince(Date()).HHmmString)" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepView.setBackground(GradientHelper.makeGradientView(frame: sleepView.bounds))
        sleepView.configure(
            model: SleepView.Model(stopTitle: "Stop", alarmTime: alarmTime.HHmmString),
            dataSource: SleepView.DataSource(
                timeLeft: { [weak self] () -> FloatingLabel.Model in
                    FloatingLabel.Model(text: self?.timeLeft ?? "", alpha: 1)
                },
                currentTime: { [weak self] () -> String in
                    self?.currentTime ?? ""
                }
            ),
            stopHandler: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
    }
}
