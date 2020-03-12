//
//  UpdatePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UpdatePlan {
    func execute(wakeUpTime: Date?, sleepDurationMin: Int?, planDurationDays: Int?) throws
}

final class UpdatePlanUseCase: UpdatePlan {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(wakeUpTime: Date?, sleepDurationMin: Int?, planDurationDays: Int?) throws {
        let plan = try planRepository.get()
        
        var updatedWakeUpTime: Date?
        var updatedSleepDuration: Double?
        var updatedPlanEndDay: Date?
        
        if let newWakeUpTime = wakeUpTime {
            let oldWakeUpTime = plan.finalWakeUpTime
            var oldWakeUpComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                              from: oldWakeUpTime)
            let newWakeUpComponents = calendar.dateComponents([.hour, .minute],
                                                              from: newWakeUpTime)
            if oldWakeUpComponents.hour != newWakeUpComponents.hour
                || oldWakeUpComponents.minute != newWakeUpComponents.minute
            {
                oldWakeUpComponents.hour = newWakeUpComponents.hour
                oldWakeUpComponents.minute = newWakeUpComponents.minute
                updatedWakeUpTime = calendar.date(bySettingHour: newWakeUpComponents.hour!,
                                                  minute: newWakeUpComponents.minute!,
                                                  second: 0,
                                                  of: oldWakeUpTime)
            }
        }
        
        if let newSleepDuration = sleepDurationMin {
            let newSleepDuration = newSleepDuration.toSeconds()
            if plan.sleepDurationSec != newSleepDuration {
                updatedSleepDuration = newSleepDuration
            }
        }
        
        if let newPlanDuration = planDurationDays {
            let oldPlanDuration = plan.dateInterval.durationDays
            let oldPlanDaysCompleted = DateInterval(start: plan.dateInterval.start,
                                                    end: plan.latestConfirmedDay).durationDays
            if oldPlanDuration != newPlanDuration
                && oldPlanDaysCompleted < newPlanDuration
            {
                let durationDiff = oldPlanDuration - newPlanDuration
                let oldPlanEndDate = plan.dateInterval.end
                updatedPlanEndDay = oldPlanEndDate.appending(days: durationDiff)
            }
        }
        
        try planRepository.update(plan:
            RisePlan(
                dateInterval: DateInterval(start: plan.dateInterval.start,
                                           end: updatedPlanEndDay ?? plan.dateInterval.end),
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
