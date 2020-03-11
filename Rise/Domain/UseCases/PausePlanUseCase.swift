//
//  PausePlanUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 10.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PausePlan {
    func execute(pause: Bool) throws
    func checkIfPaused() throws -> Bool
}

final class PausePlanUseCase: PausePlan {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(pause: Bool) throws {
        var updatedDaysMissed: Int?
        var updatedConfirmedDay: Date?
        var updatedPlanEndDate: Date?
        let plan = try planRepository.get()
        if !pause {
            let missedDays = DateInterval(start: plan.latestConfirmedDay,
                                           end: Date().noon).durationDays
            if missedDays > 0 {
                updatedConfirmedDay = Date().noon
                updatedDaysMissed = plan.daysMissed + missedDays
                updatedPlanEndDate = plan.dateInterval.end.appending(days: missedDays)
            }
        }
        let updatedPlan = RisePlan(dateInterval: DateInterval(start: plan.dateInterval.start,
                                                              end: updatedPlanEndDate ?? plan.dateInterval.end),
                                   firstSleepTime: plan.firstSleepTime,
                                   finalWakeUpTime: plan.finalWakeUpTime,
                                   sleepDurationSec: plan.sleepDurationSec,
                                   dailyShiftMin: plan.dailyShiftMin,
                                   latestConfirmedDay: updatedConfirmedDay ?? plan.latestConfirmedDay,
                                   daysMissed: updatedDaysMissed ?? plan.daysMissed,
                                   paused: pause)
        try planRepository.update(plan: updatedPlan)
    }
    
    func checkIfPaused() throws -> Bool {
        try planRepository.get().paused
    }
}
