//
//  PausePlanUseCase.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PausePlan {
    func callAsFunction(_ pause: Bool) throws
    func checkIfPaused() throws -> Bool
}

final class PausePlanUseCase: PausePlan {
    private let planRepository: RisePlanRepository
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func callAsFunction(_ pause: Bool) throws {
        var updatedDaysMissed: Int?
        var updatedPlanEndDate: Date?
        let plan = try planRepository.get()
        if !pause {
            let pausedDays = DateInterval(start: plan.latestConfirmedDay, end: NoonedDay.today.date).durationDays
            assert(pausedDays >= 0)
            updatedDaysMissed = plan.daysMissed + pausedDays
            updatedPlanEndDate = plan.dateInterval.end.appending(days: pausedDays)
        }
        try planRepository.update(plan:
            RisePlan(
                dateInterval: DateInterval(start: plan.dateInterval.start,
                                           end: updatedPlanEndDate ?? plan.dateInterval.end),
                firstSleepTime: plan.firstSleepTime,
                finalWakeUpTime: plan.finalWakeUpTime,
                sleepDurationSec: plan.sleepDurationSec,
                dailyShiftMin: plan.dailyShiftMin,
                latestConfirmedDay: NoonedDay.today.date,
                daysMissed: updatedDaysMissed ?? plan.daysMissed,
                paused: pause)
        )
    }
    
    func checkIfPaused() throws -> Bool {
        try planRepository.get().paused
    }
}
