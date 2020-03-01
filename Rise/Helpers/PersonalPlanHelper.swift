//
//  PersonalPlanHelper.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PersonalPlanHelper {
    // MARK: - Make plan -
    static func makePlan(
        sleepDurationMin: Minutes,
        wakeUpTime: Date,
        planDuration: Days,
        wentSleepTime: Date
    ) -> PersonalPlan? {
        let sleepDurationSec = Seconds(with: sleepDurationMin)
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Day.today.date)
        let wentSleepComponents = calendar.dateComponents([.hour, .minute], from: wentSleepTime)
        todayComponents.hour = wentSleepComponents.hour
        todayComponents.minute = wentSleepComponents.minute
        guard let planStartDate = calendar.date(from: todayComponents)
            else {
                return nil
        }
        guard let planEndDate = planStartDate.appending(days: planDuration)
            else {
                return nil
        }
        let planDateInterval = DateInterval(start: planStartDate, end: planEndDate)
        let sleepTime = wakeUpTime.addingTimeInterval(-sleepDurationSec)
        let timeBetweenNeededSleepAndActualSleep = Int(wentSleepTime.timeIntervalSince(sleepTime) / 60)
        let dailyShiftMin = timeBetweenNeededSleepAndActualSleep > 1440
            ? (timeBetweenNeededSleepAndActualSleep - 1440) / planDuration
            : timeBetweenNeededSleepAndActualSleep / planDuration
        
        return PersonalPlan(
            paused: false,
            dailyShiftMin: dailyShiftMin,
            dateInterval: planDateInterval,
            sleepDurationSec: sleepDurationSec,
            wakeTime: wakeUpTime,
            latestConfirmedDay: planStartDate
        )
    }
    
    // MARK: - Reshedule plan -
    static func reshedule(plan: PersonalPlan) -> PersonalPlan? {
        let yesterday = Day.yesterday.date
        
        var updatedPlan = plan
        
        guard let missingDays = calendar.dateComponents([.day],
                                                        from: plan.latestConfirmedDay,
                                                        to: yesterday).day
            else {
                log(.error, with: "Plan reshedule failed, returning nil")
                return nil
        }
        
        if missingDays <= 0 {
            return updatedPlan
        }
        
        updatedPlan.latestConfirmedDay = yesterday

        updatedPlan.daysMissed += missingDays
        
        guard let newPlanEndDate = plan.dateInterval.end.appending(days: missingDays)
            else {
                log(.error, with: "Plan reshedule failed, returning nil")
                return nil
        }
        
        updatedPlan.dateInterval.end = newPlanEndDate
        
        return updatedPlan
    }
    
    // MARK: - Update plan -
    static func update(
        plan: PersonalPlan,
        with wakeUpDate: Date?,
        and sleepDuration: Minutes?,
        and planDuration: Int?
    ) -> PersonalPlan? {
        
        var newPlan = plan
        
        if let newWakeUp = wakeUpDate {
            let oldWakeUp = plan.wakeTime
            var oldWakeUpComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: oldWakeUp)
            let newWakeUpComponents = calendar.dateComponents([.hour, .minute], from: newWakeUp)
            if oldWakeUpComponents.hour != newWakeUpComponents.hour || oldWakeUpComponents.minute != newWakeUpComponents.minute {
                oldWakeUpComponents.hour = newWakeUpComponents.hour
                oldWakeUpComponents.minute = newWakeUpComponents.minute
                if let newWakeUpDate = calendar.date(from: oldWakeUpComponents) {
                    newPlan.wakeTime = newWakeUpDate
                } else {
                    log(.warning, with: "Could build wakeUp date, skipping wake up update")
                }
            }
        }
        
        if let newSleepDuration = sleepDuration {
            let newSleepDurationSec = Seconds(with: newSleepDuration)
            if newPlan.sleepDurationSec != newSleepDurationSec {
                newPlan.sleepDurationSec = newSleepDurationSec
            }
        }
        
        if let newPlanDuration = planDuration {
            let oldPlanDuration = getPlanDuration(for: plan)
            let numberOfDaysCompleted = getDaysCompleted(for: plan)
            if oldPlanDuration != newPlanDuration && numberOfDaysCompleted < newPlanDuration {
                let planDurationDiff = oldPlanDuration - newPlanDuration
                let oldPlanEndDate = plan.dateInterval.end
                if let newPlanEndDate = oldPlanEndDate.appending(days: planDurationDiff) {
                    newPlan.dateInterval.end = newPlanEndDate
                } else {
                    log(.warning, with: "Could not append \(planDurationDiff) days to date, skipping planDuration update")
                }
            }
        }
        
        return newPlan
    }
    
    // MARK: - Confirm plan -
    static func confirm(plan: PersonalPlan) -> PersonalPlan {
        var plan = plan
        plan.latestConfirmedDay = Date()
        
        return plan
    }
    
    // MARK: - Pause plan -
    static func pause(_ pause: Bool, plan: PersonalPlan) -> PersonalPlan {
        var plan = plan
        
        plan.paused = pause
        
        if pause {
            if !(calendar.isDate(plan.latestConfirmedDay, inSameDayAs: Day.yesterday.date)
                || calendar.isDate(plan.latestConfirmedDay, inSameDayAs: Day.today.date)) {
                plan.latestConfirmedDay = Day.yesterday.date
            }
            return plan
        } else {
            guard let resheduledPlan = reshedule(plan: plan)
                else {
                    log(.warning, with: "reshedule(plan:) returned nil, returning not resheduled plan")
                    return plan
            }
            return resheduledPlan
        }
    }
    
    // MARK: - Get plan info -
    static func getDailyTime(for plan: PersonalPlan, and date: Date) -> DailyPlanTime? {
        var date = date
        if plan.paused {
            log(.info, with: "plan is paused, returning dailyTime for latest confirmed day")
            date = plan.latestConfirmedDay
        }
        
        let daysSincePlanStart = getDaysSincePlanStart(for: plan, and: date)
        
        if daysSincePlanStart < 0 {
            log(.info, with: "daysSincePlanStart < 0, returning nil")
            return nil
        }
        if daysSincePlanStart == 0 {            
            guard let sleepTime = plan.dateInterval.start.appending(days: 1) else { return nil }
            let wakeTime = sleepTime.addingTimeInterval(plan.sleepDurationSec)
            
            return DailyPlanTime(
                day: date,
                wake: wakeTime,
                sleep: sleepTime
            )
        }
        if daysSincePlanStart > getPlanDuration(for: plan) {
            log(.info, with: "daysSincePlanStart > planDuration, returning dailyTime for latest plan day")
            return getDailyTime(for: plan, and: plan.dateInterval.end)
        }
        
        let timeShiftSec = Seconds(plan.dailyShiftMin * (daysSincePlanStart - plan.daysMissed) * 60)
        let sleepTime = plan.dateInterval.start.addingTimeInterval(timeShiftSec)
        let wakeTime = sleepTime.addingTimeInterval(plan.sleepDurationSec)
        
        return DailyPlanTime(
            day: date,
            wake: wakeTime,
            sleep: sleepTime
        )
    }
    
    static func getDaysMissedIncludingCurrentPeriod(for plan: PersonalPlan) -> Int {
        guard let daysBetweenTodayAndLatestConfirmed = calendar.dateComponents([.day],
                                                                               from: plan.latestConfirmedDay,
                                                                               to: Day.today.date).day
            else {
                return plan.daysMissed
        }
        
        if daysBetweenTodayAndLatestConfirmed <= 0 { return plan.daysMissed }
        
        return plan.daysMissed + daysBetweenTodayAndLatestConfirmed
    }
    
    static func getDaysSincePlanStart(for plan: PersonalPlan, and date: Date) -> Int {
        return calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: plan.dateInterval.start),
            to: calendar.startOfDay(for:date)
        ).day ?? 0
    }
    
    static func getPlanDuration(for plan: PersonalPlan) -> Int {
        return calendar.dateComponents(
            [.day],
            from: plan.dateInterval.start,
            to: plan.dateInterval.end
        ).day ?? 0
    }
    
    static func getPlannedSleepTime(for plan: PersonalPlan) -> Date {
        return plan.wakeTime.addingTimeInterval(-plan.sleepDurationSec)
    }
    
    static func getDaysCompleted(for plan: PersonalPlan) -> Int {
        calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: plan.dateInterval.start),
            to: calendar.startOfDay(for: plan.latestConfirmedDay)
        ).day ?? 0
    }
    
    static func getProgress(for plan: PersonalPlan) -> Float {
        let duration = getPlanDuration(for: plan)
        return (Float(duration - (duration - getDaysCompleted(for: plan))) / Float(duration))
    }
    
    static func isConfirmed(for day: Day, plan: PersonalPlan) -> Bool {
        if plan.paused { return true }
        return plan.latestConfirmedDay >= day.date
    }
    
    static func minutesUntilSleepToday(for plan: PersonalPlan) -> Minutes? {
        let today = Day.today.date
        guard let sleepTime = getDailyTime(for: plan, and: today)?.sleep
            else {
                return nil
        }
        
        guard let sleepTimeCorrectedDate = sleepTime
            .appending(days: getDaysMissedIncludingCurrentPeriod(for: plan))
            else {
                return nil
        }
        
        return calendar.dateComponents([.minute], from: today, to: sleepTimeCorrectedDate).minute
    }
    
    // MARK: - Get plan info as String -
    class StringRepresentation {
        static func getSleepDuration(for plan: PersonalPlan) -> String {
            return plan.sleepDurationSec.HHmmString
        }
        
        static func getWakeTime(for plan: PersonalPlan) -> String {
            return plan.wakeTime.HHmmString
        }
        
        static func getFallAsleepTime(for plan: PersonalPlan) -> String {
            return getPlannedSleepTime(for: plan).HHmmString
        }
        
        static func getPlanDuration(for plan: PersonalPlan) -> String {
            return "\(PersonalPlanHelper.getPlanDuration(for: plan))"
        }
    }
}
