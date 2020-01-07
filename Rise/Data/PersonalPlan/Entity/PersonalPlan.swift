//
//  PersonalPlanModel.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalPlan {
    var paused: Bool
    let planStartDay: Date
    var planDuration: Int
    var finalSleepTime: Date
    var finalWakeTime: Date
    var sleepDuration: TimeInterval
    var dailyTimes: [DailyPlanTime]
    var latestConfirmedDay: Date
}
