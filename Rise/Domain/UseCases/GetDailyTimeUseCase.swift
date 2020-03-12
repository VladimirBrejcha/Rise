//
//  GetDailyTimeUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 09.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetDailyTime {
    func execute(for date: Date) throws -> DailyPlanTime
}

final class GetDailyTimeUseCase: GetDailyTime {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(for date: Date) throws -> DailyPlanTime {
        let plan = try planRepository.get()
        let date = date.noon
        let daysSincePlanStart = DateInterval(start: plan.dateInterval.start, end: date)
            .durationDays - plan.daysMissed
        let toSleepTime = calculateToSleepTime(since: plan.firstSleepTime,
                                               days: daysSincePlanStart,
                                               shiftMin: plan.dailyShiftMin)
        let wakeUpTime = calculcateWakeUpTime(since: plan.firstSleepTime,
                                              days: daysSincePlanStart,
                                              shiftMin: plan.dailyShiftMin,
                                              sleepDurationSec: plan.sleepDurationSec)
        return DailyPlanTime(day: date, wake: wakeUpTime, sleep: toSleepTime)
    }
    
    // MARK: - Private -
    private func calculateToSleepTime(
        since startDate: Date,
        days durationDays: Int,
        shiftMin timeShiftMin: Int
    ) -> Date {
        startDate
            .appending(days: durationDays)
            .addingTimeInterval(minutes: timeShiftMin * durationDays)
    }
    
    private func calculcateWakeUpTime(
        since startDay: Date,
        days durationDays: Int,
        shiftMin timeShiftMin: Int,
        sleepDurationSec: Double
    ) -> Date {
        startDay
            .appending(days: durationDays - 1)
            .addingTimeInterval(minutes: timeShiftMin * durationDays)
            .addingTimeInterval(sleepDurationSec)
    }
}
