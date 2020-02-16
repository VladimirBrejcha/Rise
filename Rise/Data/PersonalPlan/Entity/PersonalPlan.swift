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
    var dailyShiftMin: Minutes
    var dateInterval: DateInterval
    var sleepDurationSec: Seconds
    var wakeTime: Date
    var latestConfirmedDay: Date
    var daysMissed: Days = 0
}
