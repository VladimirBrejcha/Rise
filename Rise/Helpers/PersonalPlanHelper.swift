//
//  PersonalPlanHelper.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let hoursMinutesDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

final class PersonalPlanHelper {
    
    // MARK: - Actions with plan -
    static func makePlan(
        sleepDurationMin: Int, wakeUpTime: Date, planDuration: Int, wentSleepTime: Date
    ) -> PersonalPlan? {
        let sleepDurationSec = Double(sleepDurationMin * 60)
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
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
    
    static func reshedule(plan: PersonalPlan) -> PersonalPlan? {
        let yesterday = Day.yesterday.date
        
        var updatedPlan = plan
        
        guard let missingDays = calendar.dateComponents([.day],
                                                        from: yesterday,
                                                        to: plan.latestConfirmedDay).day
            else {
                log("Plan reshedule failed, returning nil")
                return nil
        }
        
        if missingDays <= 0 {
            return updatedPlan
        }
        
        updatedPlan.latestConfirmedDay = yesterday

        updatedPlan.daysMissed += missingDays
        
        guard let newPlanEndDate = plan.dateInterval.end.appending(days: missingDays)
            else {
                log("Plan reshedule failed, returning nil")
                return nil
        }
        
        updatedPlan.dateInterval.end = newPlanEndDate
        
        return updatedPlan
    }
    
    static func confirm(plan: PersonalPlan) -> PersonalPlan {
        var plan = plan
        plan.latestConfirmedDay = Date()
        
        return plan
    }
    
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
                    log("reshedule(plan:) returned nil, returning not resheduled plan")
                    return plan
            }
            return resheduledPlan
        }
    }
    
    // MARK: - Additional plan info -
    static func getDailyTime(for plan: PersonalPlan, and date: Date) -> DailyPlanTime? {
        var date = date
        if plan.paused {
            log("plan is paused, returning dailyTime for latest confirmed day")
            date = plan.latestConfirmedDay
        }
        
        let daysSincePlanStart = getDaysSincePlanStart(for: plan, and: date)
        if daysSincePlanStart < 0 {
            log("daysSincePlanStart < 0, returning nil")
            return nil
        }
        if daysSincePlanStart > getPlanDuration(for: plan) {
            log("daysSincePlanStart > planDuration, returning dailyTime for latest plan day")
            return getDailyTime(for: plan, and: plan.dateInterval.end)
        }
        let timeShiftSec = Double(plan.dailyShiftMin * (daysSincePlanStart - plan.daysMissed) * 60)
        let sleepTime = plan.dateInterval.start.addingTimeInterval(timeShiftSec)
        let wakeTime = sleepTime.addingTimeInterval(plan.sleepDurationSec)
        
        return DailyPlanTime(
            day: date,
            wake: wakeTime,
            sleep: sleepTime
        )
    }
    
    static func getDaysSincePlanStart(for plan: PersonalPlan, and date: Date) -> Int {
        return calendar.dateComponents([.day], from: calendar.startOfDay(for: plan.dateInterval.start), to: calendar.startOfDay(for:date)).day ?? 0
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
    
    static func getDaysCompletedNumber(for plan: PersonalPlan) -> Int {
        calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: plan.dateInterval.start),
            to: calendar.startOfDay(for: plan.latestConfirmedDay)
        ).day ?? 0
    }
    
    static func getProgress(for plan: PersonalPlan) -> Double {
        let duration = getPlanDuration(for: plan)
        return (Double(duration - (duration - getDaysCompletedNumber(for: plan))) / Double(duration))
    }
    
    static func isConfirmedForToday(plan: PersonalPlan) -> Bool {
        return calendar.isDate(Date(), inSameDayAs: plan.latestConfirmedDay)
    }
    
    class StringRepresentation {
        static func getSleepDurationHours(for plan: PersonalPlan) -> String {
            return (plan.sleepDurationSec / 60 / 60).stringWithoutZeroFraction
        }
        
        static func getWakeTime(for plan: PersonalPlan) -> String {
            return hoursMinutesDateFormatter.string(from: plan.wakeTime)
        }
        
        static func getFallAsleepTime(for plan: PersonalPlan) -> String {
            return hoursMinutesDateFormatter.string(from: getPlannedSleepTime(for: plan))
        }
        
        static func getPlanDuration(for plan: PersonalPlan) -> String {
            return "\(PersonalPlanHelper.getPlanDuration(for: plan))"
        }
    }
}

fileprivate extension Double {
    var stringWithoutZeroFraction: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
