//
//  PersonalPlanModel.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalPlanModel {
    var planStartSleepTime: Date
    var finalWakeUpTime: Date
    var finalSleepTime: Date
    var sleepDurationSec: Double
    var planStartDate: Date
    var planEndDate: Date
    var planDuration: TimeInterval
}

class PersonalPlanBuilder {
    
    class func buildPlan(wakeUp: Date, wentSleep: Date, sleepDuration: String, planDuration: String) -> PersonalPlanModel {
        let today = Date()
        let sleepDuration = buildSleepDuration(from: sleepDuration)
        let finalSleepTime = buildFinalSleepTime(from: wakeUp, and: sleepDuration)
        let planDuration = buildPlanDuration(from: planDuration)
        let planEndDate = buildPlanEndDate(since: today, with: planDuration)
        
        return PersonalPlanModel(planStartSleepTime: wentSleep, finalWakeUpTime: wakeUp, finalSleepTime: finalSleepTime,
                                 sleepDurationSec: sleepDuration, planStartDate: today, planEndDate: planEndDate, planDuration: planDuration)
    }
    
    // MARK: - Private methods
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
        default: fatalError("index doesnt exists")
        }
    }
    
    private class func buildPlanDuration(from string: String) -> Double {
        switch string {
        case DataForPicker.daysArray[0]: return daysToSeconds(10)
        case DataForPicker.daysArray[1]: return daysToSeconds(15)
        case DataForPicker.daysArray[2]: return daysToSeconds(30)
        case DataForPicker.daysArray[3]: return daysToSeconds(50)
        default: fatalError("index doesnt exists")
        }
    }
    
    private class func buildPlanEndDate(since today: Date, with planDuration: Double) -> Date {
        return Date(timeInterval: planDuration, since: today)
    }
    
    private class func daysToSeconds(_ days: Double) -> Double {
         return days * 24 * 60 * 60
    }
    
}
