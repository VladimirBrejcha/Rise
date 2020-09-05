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
    
    private var toSleepTime: Date = Date()
    private var wakeUpTime: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var beforeSleepMotivatingText = ""
        do {
            toSleepTime = try getDailyTime(for: try! getPlan(), date: NoonedDay.today.date).sleep
            wakeUpTime = try getDailyTime(for: try! getPlan(), date: NoonedDay.tomorrow.date).wake
            
            let toSleepSinceNow = toSleepTime.timeIntervalSince(Date())
            
            if toSleepSinceNow.isNearby {
                beforeSleepMotivatingText = "You are just in time today!"
            } else if toSleepSinceNow > 0 {
                beforeSleepMotivatingText = "You are early today, sleep well"
            } else if toSleepSinceNow < 0 {
                beforeSleepMotivatingText = "You are late today :("
            }
            
        } catch PlanError.noPlanForTheDay {
            fatalError()
            // TODO: (vladimir) - handle errors
        } catch {
            fatalError()
            // TODO: (vladimir) - handle other errors
        }
        prepareToSleepView.setBackground(GradientHelper.makeGradientView(frame: view.bounds))
        prepareToSleepView.configure(
            model: PrepareToSleepView.Model(
                toSleepText: beforeSleepMotivatingText,
                title: "Prepare to sleep",
                startSleepText: "begin to sleep",
                wakeUpTitle: "Alarm at \(wakeUpTime.HHmmString)",
                wakeUpTime: wakeUpTime
            ),
            dataSource: PrepareToSleepView.DataSource(timeUntilWakeUp: { [weak self] () -> String in
                 "\(self?.wakeUpTime.timeIntervalSince(Date()).HHmmString ?? "") until wake up"
            }),
            handlers: PrepareToSleepView.Handlers(
                wakeUp: { [weak self] in
                    guard let self = self else { return }
                    self.prepareToSleepView.state = self.prepareToSleepView.state == .normal
                        ? .expanded
                        : .normal
                },
                sleep: { [weak self] in
                    guard let self = self else { return }
                    // TODO: (vladimir) - optimise routing
                    self.dismiss()
                    self.present(Story.sleep(alarmTime: self.wakeUpTime)(), with: .overContext)
                },
                close: { [weak self] in
                    self?.dismiss()
                },
                wakeUpTimeChanged: { [weak self] newValue in
                    self?.wakeUpTime = newValue
                }
            )
        )
    }
    
    // MARK: - Private -
    private func dismiss() {
        dismiss(animated: true)
    }
}

fileprivate extension TimeInterval {
    var isNearby: Bool {
        toMinutes() > -10 && toMinutes() < 10
    }
}
