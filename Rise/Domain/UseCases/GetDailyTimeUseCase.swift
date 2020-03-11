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
    private let toSleepTimeFormula: ToSleepTimeFormula
    private let wakeUpTimeFormula: WakeUpTimeFormula
    
    required init(planRepository: RisePlanRepository,
                  toSleepTimeFormula: @escaping ToSleepTimeFormula,
                  wakeUpTimeFormula: @escaping WakeUpTimeFormula
    ) {
        self.planRepository = planRepository
        self.toSleepTimeFormula = toSleepTimeFormula
        self.wakeUpTimeFormula = wakeUpTimeFormula
    }
    
    func execute(for date: Date) throws -> DailyPlanTime {
        let plan = try planRepository.get()
        let date = date.noon
        let daysSincePlanStart = DateInterval(start: plan.dateInterval.start, end: date).durationDays
        let timeShiftForTheDay = plan.dailyShiftMin * (daysSincePlanStart - plan.daysMissed)
        let toSleepTime = toSleepTimeFormula(plan.firstSleepTime, daysSincePlanStart, timeShiftForTheDay)
        let wakeUpTime = wakeUpTimeFormula(plan.firstSleepTime, daysSincePlanStart, timeShiftForTheDay, plan.sleepDurationSec)
        return DailyPlanTime(day: date, wake: wakeUpTime, sleep: toSleepTime)
    }
}
