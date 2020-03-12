//
//  ReshedulePlanUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 10.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ReshedulePlan {
    func execute() throws
}

final class ReshedulePlanUseCase: ReshedulePlan {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() throws {
        let plan = try planRepository.get()
        
        let missedDays = DateInterval(start: plan.latestConfirmedDay,
                                       end: Date().noon).durationDays
        assert(missedDays >= 0)
        
        try planRepository.update(plan:
            RisePlan(
                dateInterval: DateInterval(start: plan.dateInterval.start,
                                           end: plan.dateInterval.end.appending(days: missedDays)),
                firstSleepTime: plan.firstSleepTime,
                finalWakeUpTime: plan.finalWakeUpTime,
                sleepDurationSec: plan.sleepDurationSec,
                dailyShiftMin: plan.dailyShiftMin,
                latestConfirmedDay: NoonedDay.yesterday.date,
                daysMissed: plan.daysMissed + missedDays,
                paused: plan.paused)
        )
    }
}
