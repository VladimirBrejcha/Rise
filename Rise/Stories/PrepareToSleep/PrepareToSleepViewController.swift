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
                    guard let self = self else { return "" }
                    
                    var wakeUpTime = self.state.wakeUpTime
                    
                    // if date is out of this day
                    if wakeUpTime < Date().addingTimeInterval(-(60 * 60 * 24)) {
                        wakeUpTime = wakeUpTime.toToday().adjustDate()
                    // if date is out of this day other way
                    } else if wakeUpTime > Date().addingTimeInterval(60 * 60 * 24) { // todo try with appendingDays
                        wakeUpTime = wakeUpTime.toToday().adjustDate()
                    // if date is within the day but needs correction
                    } else if wakeUpTime < Date() {
                        wakeUpTime = wakeUpTime.adjustDate()
                    }
                    
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
    var timeIntervalSinceNow: TimeInterval {
        timeIntervalSince(Date())
    }
    
    func toToday() -> Date {
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateComponents = calendar.dateComponents([.hour, .minute], from: self)
        guard
            let newDate = calendar.date(
                from: DateComponents(
                    year: todayComponents.year,
                    month: todayComponents.month,
                    day: todayComponents.day,
                    hour: dateComponents.hour,
                    minute: dateComponents.minute
                )
            ) else {
                fatalError()
        }
        return newDate
    }

    func adjustDate() -> Date {
        if self < Date() {
            let tomorrow = Date().addingTimeInterval(60 * 60 * 24)
            let tomorrowComponents = calendar.dateComponents([.year, .month, .day], from: tomorrow)
            let dateComponents = calendar.dateComponents([.hour, .minute], from: self)
            guard
                let newDate = calendar.date(
                    from: DateComponents(
                        year: tomorrowComponents.year,
                        month: tomorrowComponents.month,
                        day: tomorrowComponents.day,
                        hour: dateComponents.hour,
                        minute: dateComponents.minute
                    )
                ) else {
                    fatalError()
            }
            return newDate
        }
        return self
    }
}

fileprivate extension TimeInterval {
    var isNearby: Bool {
        toMinutes() > -10 && toMinutes() < 10
    }
}
