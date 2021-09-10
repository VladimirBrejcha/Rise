//
//  RisePlan.swift
//  Rise
//
//  Created by Vladimir Korolev on 29/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct RisePlan: Equatable {
    let dateInterval: DateInterval
    let firstSleepTime: Date
    let finalWakeUpTime: Date
    let sleepDurationSec: Double
    let dailyShiftMin: Int
    let latestConfirmedDay: Date
    let daysMissed: Int
    let paused: Bool
}
