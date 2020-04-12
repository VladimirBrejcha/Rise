//
//  SleepPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 13.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SleepPresenter: SleepViewOutput {
    private weak var view: SleepViewInput?
    
    private let alarmAt: Date
    
    var currentTime: String { Date().HHmmString }
    var timeLeft: String { "Time left \(alarmAt.timeIntervalSince(Date()).HHmmString)" }
    
    required init(view: SleepViewInput, alarmAt: Date) {
        self.view = view
        self.alarmAt = alarmAt
    }
    
    func viewDidLoad() {
        view?.setAlarmTime(alarmAt.HHmmString)
    }
    
    func stopPressed() {
        view?.dismiss()
    }
}
