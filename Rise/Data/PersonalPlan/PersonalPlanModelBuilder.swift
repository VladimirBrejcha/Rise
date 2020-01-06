//
//  PersonalPlanModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanModelBuilder {
    func buildModel(from object: RisePersonalPlan) -> PersonalPlan {
        let dailyTimes = (Array(object.daliyPlanTime) as! Array<RiseDailyPlanTime>)
            .sorted { $0.day < $1.day }
            .map { buildDailyTimeModel(from: $0) }
        
        return PersonalPlan(state: object.state, planStartDay: object.planStartDay,
                            planDuration: Int(object.planDuration), finalSleepTime: object.finalSleepTime,
                            finalWakeTime: object.finalWakeTime, sleepDuration: object.sleepDuration,
                            dailyTimes: dailyTimes, latestConfirmedDay: object.latestConfirmedDay)
    }
    
    func update(object: RisePersonalPlan, with model: PersonalPlan, and planTime: [RiseDailyPlanTime]) {
        object.state = model.state
        object.planStartDay = model.planStartDay
        object.planDuration = Int64(model.planDuration)
        object.finalSleepTime = model.finalSleepTime
        object.finalWakeTime = model.finalWakeTime
        object.sleepDuration = model.sleepDuration
        object.removeFromDaliyPlanTime(object.daliyPlanTime)
        object.addToDaliyPlanTime(NSSet(array: planTime))
        object.latestConfirmedDay = model.latestConfirmedDay
    }
    
    func update(object: RiseDailyPlanTime, with model: DailyPlanTime) {
        object.day = model.day
        object.sleep = model.sleep
        object.wake = model.wake
    }
    
    private func buildDailyTimeModel(from object: RiseDailyPlanTime) -> DailyPlanTime {
        return DailyPlanTime(day: object.day, wake: object.wake, sleep: object.sleep)
    }
}
