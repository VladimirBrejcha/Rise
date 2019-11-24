//
//  ModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanConfigurator {
    class func configure(wakeUpTime: Date, sleepDuration: String, planDuration: String, wentSleepTime: Date) -> PersonalPlan {
        let today = Date()
        let planDuration = buildPlanDuration(from: planDuration)
        
        let sleepDurationTime = buildSleepDuration(from: sleepDuration)
        let finalSleepTime = buildFinalSleepTime(from: wakeUpTime, and: sleepDurationTime)
        
        let timeBetweenNeededSleepAndActualSleep = Int(wentSleepTime.timeIntervalSince(finalSleepTime) / 60)
        
        let dailyShiftMin: Int = timeBetweenNeededSleepAndActualSleep > 1440
            ? -(timeBetweenNeededSleepAndActualSleep - 1440) / planDuration
            : -timeBetweenNeededSleepAndActualSleep / planDuration
        
        var dailyPlanTimesArray: [DailyPlanTime] = []
        
        for day in 1 ..< planDuration + 1 {
            let dayDate = Calendar.current.date(byAdding: .day, value: day, to: today)!
            let sleepDate = Calendar.current.date(byAdding: .minute, value: dailyShiftMin * day, to: wentSleepTime)!
            let wakeDate = sleepDate.addingTimeInterval(sleepDurationTime)
            let dailyPlanModel = DailyPlanTime(day: dayDate, wake: wakeDate, sleep: sleepDate)
            dailyPlanTimesArray.append(dailyPlanModel)
        }
        return PersonalPlan(planStartDay: today, planDuration: planDuration, finalSleepTime: finalSleepTime,
                            finalWakeTime: wakeUpTime, sleepDuration: sleepDurationTime,
                            dailyTimes: dailyPlanTimesArray, latestConfirmedDay: today)
    }
    
    private class func buildFinalSleepTime(from wakeUp: Date, and sleepDuration: Double) -> Date {
        return Date(timeInterval: -sleepDuration, since: wakeUp)
    }
    
    private class func buildSleepDuration(from string: String) -> Double {
        switch string
        {
        case DataForPicker.hoursArray[0]: return 420 * 60
        case DataForPicker.hoursArray[1]: return 450 * 60
        case DataForPicker.hoursArray[2]: return 480 * 60
        case DataForPicker.hoursArray[3]: return 510 * 60
        case DataForPicker.hoursArray[4]: return 540 * 60
        default: fatalError("index doesnt exist")
        }
    }
    
    private class func buildPlanDuration(from string: String) -> Int {
        switch string {
        case DataForPicker.daysArray[0]: return 10
        case DataForPicker.daysArray[1]: return 15
        case DataForPicker.daysArray[2]: return 30
        case DataForPicker.daysArray[3]: return 50
        default: fatalError("index doesnt exist")
        }
    }
    
    private class func buildPlanEndDate(since today: Date, with planDuration: Double) -> Date {
        return Date(timeInterval: planDuration, since: today)
    }
    
    private class func daysToSeconds(_ days: Int) -> Double {
        return Double(days * 24 * 60 * 60)
    }
}


