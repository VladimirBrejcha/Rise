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
    
    var getDailyTime: GetDailyTime! // DI
    
    private var toSleepTime: Date = Date()
    private var wakeUpTime: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var beforeSleepMotivatingText = ""
        do {
            toSleepTime = try getDailyTime(for: NoonedDay.today.date).sleep
            wakeUpTime = try getDailyTime(for: NoonedDay.tomorrow.date).wake
            
            let toSleepSinceNow = toSleepTime.timeIntervalSince(Date())
            
            if toSleepSinceNow.isNearby {
                beforeSleepMotivatingText = "You are just in time today!"
            } else if toSleepSinceNow > 0 {
                beforeSleepMotivatingText = "You are early today, sleep well"
            } else if toSleepSinceNow < 0 {
                beforeSleepMotivatingText = "You are late today :("
            }
            
        } catch RiseError.noPlanForTheDay {
            fatalError()
            // TODO: (vladimir) - handle errors
        } catch {
            fatalError()
            // TODO: (vladimir) - handle other errors
        }
        prepareToSleepView.setBackground(
            GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        )
        prepareToSleepView.model = PrepareToSleepView.Model(
            toSleepText: beforeSleepMotivatingText,
            title: "Prepare to sleep",
            timeUntilWakeUpDataSource: { [weak self] in
                "\(self?.wakeUpTime.timeIntervalSince(Date()).HHmmString ?? "") until wake up"
            },
            startSleepText: "begin to sleep",
            wakeUpTitle: "Alarm at \(wakeUpTime.HHmmString)",
            wakeUpTime: wakeUpTime,
            wakeUpTouchHandler: { [weak self] in
                guard let self = self else { return }
                self.prepareToSleepView.state = self.prepareToSleepView.state == .normal
                    ? .expanded
                    : .normal
            },
            startSleepHandler: { [weak self] in
                guard let self = self else { return }
                // TODO: (vladimir) - optimise routing
                self.dismiss()
                self.present(Story.sleep(alarmTime: self.wakeUpTime)(), with: .overContext)
            },
            closeHandler: { [weak self] in
                self?.dismiss()
            },
            wakeUpValueChangedHandler: { [weak self] newValue in
                self?.wakeUpTime = newValue
            }
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
