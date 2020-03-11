//
//  PersonalPlan.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct RisePlan {
    let dateInterval: DateInterval
    let firstSleepTime: Date
    let finalWakeUpTime: Date
    let sleepDurationSec: Double
    let dailyShiftSec: Double
    let latestConfirmedDay: Date
    let daysMissed: Int
    let paused: Bool
}
