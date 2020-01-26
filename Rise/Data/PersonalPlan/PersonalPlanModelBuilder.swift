//
//  PersonalPlanModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PersonalPlanModelBuilder {
    func buildModel(from object: RisePersonalPlan) -> PersonalPlan {
        return PersonalPlan(
            paused: object.paused,
            dailyShiftMin: Int(object.dailyShiftMin),
            dateInterval: DateInterval(start: object.planStartDay, end: object.planEndDay),
            sleepDurationSec: object.sleepDurationSec,
            wakeTime: object.wakeTime,
            latestConfirmedDay: object.latestConfirmedDay,
            daysMissed: Int(object.daysMissed)
        ) 
    }
    
    func update(object: RisePersonalPlan, with model: PersonalPlan) {
        object.paused = model.paused
        object.dailyShiftMin = Int64(model.dailyShiftMin)
        object.planStartDay = model.dateInterval.start
        object.planEndDay = model.dateInterval.end
        object.wakeTime = model.wakeTime
        object.sleepDurationSec = model.sleepDurationSec
        object.latestConfirmedDay = model.latestConfirmedDay
        object.daysMissed = Int64(model.daysMissed)
    }
}
