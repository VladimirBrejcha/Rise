//
//  PersonalPlanModel.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalPlanModel {
    var planStartSleepTime: Date
    var finalWakeUpTime: Date
    var finalSleepTime: Date
    var sleepDurationSec: Double
    var planStartDate: Date
    var planEndDate: Date
    var planDuration: TimeInterval
}


struct NewPersonalPlanModel {
    var planStartDay: Date
    var planDuration: TimeInterval // probably int?
    var finalSleepTime: Date
    var finalWakeTime: Date
    var sleepDuration: TimeInterval
    var dailyTimes: [DailyTimesModel]
    var latestConfirmedDay: Date
}

struct DailyTimesModel {
    var sunrise: Date
    var sunset: Date
    var wake: Date
    var sleep: Date
}
