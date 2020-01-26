//
//  PersonalPlan.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalPlan {
    var paused: Bool
    var dailyShiftMin: Int
    var dateInterval: DateInterval
    var sleepDurationSec: TimeInterval
    var wakeTime: Date
    var latestConfirmedDay: Date
    var daysMissed: Int = 0
}
