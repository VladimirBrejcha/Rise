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
    private var editingAlarmTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepView.setBackground(GradientHelper.makeGradientView(frame: sleepView.bounds))
        sleepView.configure(
            initialModel: SleepView.Model(state: .normal, alarm: alarmTime),
            dataSource: SleepView.DataSource(
                timeLeft: { [weak self] in
                    if let timeLeft = self?.alarmTime.fixIfNeeded().timeIntervalSince(Date()).HHmmString {
                        return FloatingLabel.Model(text: "Time left \(timeLeft)", alpha: 1)
                    } else {
                        return FloatingLabel.Model(text: "", alpha: 0)
                    }
                },
                currentTime: { Date().HHmmString }
            ),
            editAlarmHandler: { [weak self] in
                guard let self = self else { return }
                self.sleepView.model = self.sleepView.model?.changing { $0.state = .editingAlarm }
            },
            cancelAlarmEditHandler: { [weak self] in
                guard let self = self else { return }
                self.sleepView.model = self.sleepView.model?.changing { $0.state = .normal }
                self.editingAlarmTime = nil
            },
            saveAlarmEditHandler: { [weak self] in
                guard let self = self else { return }
                if let newAlarmTime = self.editingAlarmTime {
                    self.alarmTime = newAlarmTime
                    self.sleepView.model = SleepView.Model(state: .normal, alarm: newAlarmTime)
                } else {
                    self.sleepView.model = self.sleepView.model?.changing { $0.state = .normal }
                }
                self.editingAlarmTime = nil
            },
            alarmTimeChangedHandler: { [weak self] time in
                self?.editingAlarmTime = time
            },
            stopHandler: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
    }
}

fileprivate extension Date {
    func fixIfNeeded() -> Date {
        if self < Date() {
            return self.changeDayStoringTime(to: .tomorrow)
        } else {
            return self
        }
    }
}
