//
//  UpdatePlan.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UpdatePlan {
    func callAsFunction(wakeUpTime: Date?, sleepDurationMin: Int?, planDurationDays: Int?) throws
}

final class UpdatePlanUseCase: UpdatePlan {
    private let planRepository: RisePlanRepository
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func callAsFunction(wakeUpTime: Date?, sleepDurationMin: Int?, planDurationDays: Int?) throws {
        let plan = try planRepository.get()
        
        var updatedWakeUpTime: Date?
        var updatedSleepDuration: Double?
        var updatedPlanEndDay: Date?
        
        if let newWakeUpTime = wakeUpTime {
            updatedWakeUpTime = calculateWakeUpTime(new: newWakeUpTime, old: plan.finalWakeUpTime)
        }
        if let newSleepDuration = sleepDurationMin {
            let newSleepDuration = newSleepDuration.toSeconds()
            if plan.sleepDurationSec != newSleepDuration {
                updatedSleepDuration = newSleepDuration
            }
        }
        if let newPlanDuration = planDurationDays {
            updatedPlanEndDay = calculateEndDay(for: plan.dateInterval,
                                                and: plan.latestConfirmedDay,
                                                newDuration: newPlanDuration)
        }
        
        try planRepository.update(plan:
            RisePlan(
                dateInterval: DateInterval(start: plan.dateInterval.start, end: updatedPlanEndDay ?? plan.dateInterval.end),
                firstSleepTime: plan.firstSleepTime,
                finalWakeUpTime: updatedWakeUpTime ?? plan.finalWakeUpTime,
                sleepDurationSec: updatedSleepDuration ?? plan.sleepDurationSec,
                dailyShiftMin: plan.dailyShiftMin,
                latestConfirmedDay: plan.latestConfirmedDay,
                daysMissed: plan.daysMissed,
                paused: plan.paused
            )
        )
    }
}

// MARK: - Private -
private func calculateWakeUpTime(new newWakeUpTime: Date, old oldWakeUpTime: Date) -> Date? {
    calendar.date(bySettingHour: calendar.component(.hour, from: newWakeUpTime),
                  minute: calendar.component(.minute, from: newWakeUpTime),
                  second: 0,
                  of: oldWakeUpTime)
}

private func calculateEndDay(for dateInterval: DateInterval, and latestConfirmedDay: Date, newDuration: Int) -> Date {
    let oldDuration = dateInterval.durationDays
    let daysCompleted = DateInterval(start: dateInterval.start, end: latestConfirmedDay).durationDays
    return newDuration == oldDuration || daysCompleted > newDuration
        ? dateInterval.end
        : dateInterval.end.appending(days: oldDuration - newDuration)
}
