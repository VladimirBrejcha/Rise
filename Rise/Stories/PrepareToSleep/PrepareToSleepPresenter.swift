//
//  PrepareToSleepPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PrepareToSleepPresenter: PrepareToSleepViewOutput {
    private weak var view: PrepareToSleepViewInput?
    
    private let getDailyTime: GetDailyTime
    
    private var toSleepTime: Date = Date()
    private var wakeUpTime: Date = Date()
    private var sleepDuration: Double {
        wakeUpTime.timeIntervalSince(Date())
    }
    
    required init(
        view: PrepareToSleepViewInput,
        getDailyTime: GetDailyTime
    ) {
        self.view = view
        self.getDailyTime = getDailyTime
    }
    
    // MARK: - PrepareToSleepViewOutput -
    func viewDidLoad() {
        do {
            toSleepTime = try getDailyTime(for: NoonedDay.today.date).sleep
            wakeUpTime = try getDailyTime(for: NoonedDay.tomorrow.date).wake
            let toSleepSinceNow = toSleepTime.timeIntervalSince(Date())
            if toSleepSinceNow.isNearby {
                view?.updateToSleep(with: "You are just in time today!")
            } else if toSleepSinceNow > 0 {
                view?.updateToSleep(with: "You are early today, sleep well")
            } else if toSleepSinceNow < 0 {
                view?.updateToSleep(with: "You are late today :(")
            }
            beginSleepDurationRefreshing()
            view?.updatePicker(with: wakeUpTime)
            view?.updateWakeUp(with: "Alarm at \(wakeUpTime.HHmmString)")
        } catch RiseError.noPlanForTheDay {
            fatalError()
        } catch {
            fatalError()
            // todo handle other errors
        }
    }
    
    func startPressed() {
        view?.close()
        view?.presentSleep(with: wakeUpTime)
    }
    
    func closePressed() {
        view?.close()
    }
    
    func pickerValueChanged(_ value: Date) {
        wakeUpTime = value
        updateSleepDuration()
    }
    
    // MARK: - Private -
    private func beginSleepDurationRefreshing() {
        updateSleepDuration()
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateSleepDuration()
        }
    }
    
    private func updateSleepDuration() {
        view?.updateSleepDuration(with: "\(sleepDuration.HHmmString) until wake up")
    }
}

fileprivate extension TimeInterval {
    var isNearby: Bool {
        self.toMinutes() > -10 && self.toMinutes() < 10
    }
}
