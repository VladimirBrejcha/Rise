//
//  PrepareToSleepViewController.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

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
        } catch PlanError.planDoesNotExist {
            if let previouslySelectedWakeUpTime = previouslySelectedWakeUpTime {
                state.wakeUpTime = previouslySelectedWakeUpTime
            }
        } catch {
            log(.info, error.localizedDescription)
            if let previouslySelectedWakeUpTime = previouslySelectedWakeUpTime {
                state.wakeUpTime = previouslySelectedWakeUpTime
            }
        }
        
        prepareToSleepView.configure(
            model: PrepareToSleepView.Model(
                toSleepText: motivatingText,
                title: "Prepare to sleep",
                startSleepText: "begin to sleep",
                wakeUpTitle: "Alarm at \(state.wakeUpTime.HHmmString)",
                wakeUpTime: state.wakeUpTime
            ),
            dataSource: PrepareToSleepView.DataSource(
                timeUntilWakeUp: { [weak self] () -> String in
                    guard let self = self else { return "" }
                    let wakeUpTime = self.state.wakeUpTime.fixIfNeeded()
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
                    self.navigationController?.setViewControllers([Story.sleep(alarmTime: self.state.wakeUpTime)()], animated: true)
                },
                close: { [weak self] in
                    self?.dismiss()
                },
                wakeUpTimeChanged: { [weak self] newValue in
                    self?.previouslySelectedWakeUpTime = newValue
                    self?.state.wakeUpTime = newValue
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
