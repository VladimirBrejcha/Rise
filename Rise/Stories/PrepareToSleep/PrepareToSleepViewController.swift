//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PrepareToSleepViewController: UIViewController {

    @IBOutlet private var prepareToSleepView: PrepareToSleepView!
    
    var getSchedule: GetSchedule! // DI
    
    @UserDefault<Date>("previously_selected_wakeup_time")
    private var previouslySelectedWakeUpTime: Date?

    private var wakeUpTime: Date {
        schedule?.wakeUp ?? previouslySelectedWakeUpTime ?? Date()
    }

    private var schedule: Schedule?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        schedule = getSchedule.today()
        
        prepareToSleepView.configure(
            model: PrepareToSleepView.Model(
                toSleepText: motivatingText,
                title: "Prepare to sleep",
                startSleepText: "begin to sleep",
                wakeUpTitle: "Alarm at \(wakeUpTime.HHmmString)",
                wakeUpTime: wakeUpTime
            ),
            dataSource: PrepareToSleepView.DataSource(
                timeUntilWakeUp: { [weak self] () -> String in
                    guard let self = self else { return "" }
                    let wakeUpTime = self.wakeUpTime.fixIfNeeded()
                    return "\(wakeUpTime.timeIntervalSinceNow.HHmmString) until wake up"
                }
            ),
            handlers: PrepareToSleepView.Handlers(
                wakeUp: { [weak self] in
                    if let self = self {
                        self.prepareToSleepView.state = self.prepareToSleepView.state == .normal
                            ? .expanded
                            : .normal
                    }
                },
                sleep: { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.setViewControllers(
                        [Story.sleep(alarmTime: self.wakeUpTime)()],
                        animated: true
                    )
                },
                close: { [weak self] in
                    self?.dismiss()
                },
                wakeUpTimeChanged: { [weak self] newValue in
                    self?.previouslySelectedWakeUpTime = newValue
                    self?.prepareToSleepView.model = self?.prepareToSleepView.model?.changing { model in
                        model.wakeUpTime = newValue
                        model.wakeUpTitle = "Alarm at \(newValue.HHmmString)"
                    }
                }
            )
        )
    }
    
    // MARK: - Private -

    private func dismiss() {
        dismiss(animated: true)
    }
    
    // MARK: - Make motivating text

    private var motivatingText: String {
        if let time = schedule?.toBed {
            return makeMotivatingText(with: time)
        } else {
            return "Have a good night!"
        }
    }
    
    private func makeMotivatingText(with time: Date) -> String {
        let timeSinceNow = time.timeIntervalSinceNow
        if timeSinceNow.isNearby {
            return "You are just in time today!"
        } else if timeSinceNow > 0 {
            return "Good night, sleep well"
        } else /* if timeSinceNow < 0 */ {
            return "You are a little late today, it happens with all of us. Sleep well!"
        }
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

fileprivate extension TimeInterval {
    var isNearby: Bool {
        toMinutes() > -10 && toMinutes() < 10
    }
}
