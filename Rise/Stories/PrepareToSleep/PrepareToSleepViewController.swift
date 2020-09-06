//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

// TODO: (vladimir) - Resolve the bugs with time until wake up counter:
// 1. If days changes, negative value appears
// 2. Wrong calculations

final class PrepareToSleepViewController: UIViewController {
    @IBOutlet private var prepareToSleepView: PrepareToSleepView!
    
    var getPlan: GetPlan! // DI
    var getDailyTime: GetDailyTime! // DI
    
    @UserDefault<Date>("previouslySelectedWakeUpTime")
    private var previouslySelectedWakeUpTime: Date?
    
    // MARK: - State
    private struct State {
        var plan: RisePlan? = nil
        var toSleepTime: Date? = nil
        var wakeUpTime: Date
    }
    private var state: State = State(wakeUpTime: Date())
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let plan = try getPlan()
            state.plan = plan
            state.toSleepTime = try getDailyTime(for: plan, date: NoonedDay.today.date).sleep
            state.wakeUpTime = try getDailyTime(for: plan, date: NoonedDay.tomorrow.date).wake
        } catch {
            log(.info, with: error.localizedDescription)
            if let previouslySelectedWakeUpTime = previouslySelectedWakeUpTime {
                state.wakeUpTime = previouslySelectedWakeUpTime
            }
        }
        
        prepareToSleepView.configure(
            model: PrepareToSleepView.Model(
                background: GradientHelper.makeGradientView(frame: view.bounds),
                toSleepText: motivatingText,
                title: "Prepare to sleep",
                startSleepText: "begin to sleep",
                wakeUpTitle: "Alarm at \(state.wakeUpTime.HHmmString)",
                wakeUpTime: state.wakeUpTime
            ),
            dataSource: PrepareToSleepView.DataSource(
                timeUntilWakeUp: { [weak self] () -> String in
                    "\(self?.state.wakeUpTime.timeIntervalSinceNow.HHmmString ?? "time") until wake up"
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
                    // TODO: (vladimir) - optimise routing
                    self.dismiss()
                    self.present(Story.sleep(alarmTime: self.state.wakeUpTime)(), with: .overContext)
                },
                close: { [weak self] in
                    self?.dismiss()
                },
                wakeUpTimeChanged: { [weak self] newValue in
                    var time = newValue
                    if time < Date() {
                        let tomorrow = Date().addingTimeInterval(60 * 60 * 24)
                        let tomorrowComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
                        let newValueComponents = calendar.dateComponents([.hour, .minute], from: newValue)
                        let newDate = calendar.date(
                            from: DateComponents(
                                year: tomorrowComponents.year,
                                month: tomorrowComponents.month,
                                day: tomorrowComponents.day,
                                hour: newValueComponents.hour,
                                minute: newValueComponents.minute
                            )
                        )
                        time = newDate!
                    } else if time.timeIntervalSinceNow > 60 * 60 * 24 {
                        let today = Date()
                        let todayComponents = calendar.dateComponents([.year, .month, .day], from: today)
                        let newValueComponents = calendar.dateComponents([.hour, .minute], from: newValue)
                        let newDate = calendar.date(
                            from: DateComponents(
                                year: todayComponents.year,
                                month: todayComponents.month,
                                day: todayComponents.day,
                                hour: newValueComponents.hour,
                                minute: newValueComponents.minute
                            )
                        )
                        time = newDate!
                    }
                    self?.previouslySelectedWakeUpTime = time
                    self?.state.wakeUpTime = time
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
        if let time = state.toSleepTime {
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
            return "You are a little late today, this happens to all of us. Sleep well!"
        }
    }
}

fileprivate extension Date {
    var timeIntervalSinceNow: TimeInterval {
        timeIntervalSince(Date())
    }
}

fileprivate extension TimeInterval {
    var isNearby: Bool {
        toMinutes() > -10 && toMinutes() < 10
    }
}
