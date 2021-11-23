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
    var preferredWakeUpTime: PreferredWakeUpTime! // DI
    var suggestKeepAppOpened: SuggestKeepAppOpened! // DI

    private var customSelectedWakeUpTime: Date?

    private var wakeUpTime: Date {
        if let schedule = schedule {
            return customSelectedWakeUpTime ?? schedule.wakeUp
        } else {
            return customSelectedWakeUpTime ?? preferredWakeUpTime.time ?? Date()
        }
    }

    private var schedule: Schedule?

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let hours = calendar.dateComponents([.hour], from: Date()).hour else {
            dismiss()
            return
        }

        if hours < 6 {
            schedule = getSchedule.today()
        } else {
            schedule = getSchedule.tomorrow()
        }
        
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
                    if self.suggestKeepAppOpened.shouldSuggest {
                        self.suggestKeepAppOpened.shouldSuggest = false
                        self.present(
                            Story.keepAppOpenedSuggestion(completion: {
                                self.goToSleep()
                            })(),
                            with: .fullScreen
                        )
                    } else {
                        self.goToSleep()
                    }
                },
                close: { [weak self] in
                    self?.dismiss()
                },
                wakeUpTimeChanged: { [weak self] newValue in
                    self?.customSelectedWakeUpTime = newValue
                    self?.preferredWakeUpTime.time = newValue
                    self?.prepareToSleepView.model = self?.prepareToSleepView.model?.changing { model in
                        model.wakeUpTime = newValue
                        model.wakeUpTitle = "Alarm at \(newValue.HHmmString)"
                    }
                }
            )
        )
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

    // MARK: - Private -

    private func dismiss() {
        dismiss(animated: true)
    }

    private func goToSleep() {
        navigationController?.setViewControllers(
            [Story.sleep(alarmTime: wakeUpTime)()],
            animated: true
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

    var timeIntervalSinceNow: TimeInterval {
        timeIntervalSince(Date())
    }
}

fileprivate extension TimeInterval {
    var isNearby: Bool {
        toMinutes() > -10 && toMinutes() < 10
    }
}
