//
//  Formulas.swift
//  Rise
//
//  Created by Владимир Королев on 09.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias DailyShiftFormula = (Date, Date, Double) -> Double
typealias ToSleepTimeFormula = (Date, Int, Double) -> Date
typealias WakeUpTimeFormula = (Date, Int, Double, Double) -> Date
typealias DateIntervalFormula = (Date, Int) -> DateInterval

struct Formulas {
    static let defaultDailyShiftFormula: DailyShiftFormula = { firstSleepTime, finalSleepTime, duration in
        firstSleepTime > finalSleepTime
            ? -(firstSleepTime.timeIntervalSince(finalSleepTime) / duration)
            : finalSleepTime.timeIntervalSince(firstSleepTime) / duration
    }
    
    static let defaultToSleepTimeFormula: ToSleepTimeFormula = { firstSleepTime, numberOfDays, dailyShift in
        firstSleepTime
            .appending(days: numberOfDays)!
            .addingTimeInterval(dailyShift * Double(numberOfDays))
    }
    
    static let defaultWakeUpTimeFormula: WakeUpTimeFormula = { firstSleepTime, numberOfDays, dailyShift, sleepDuration in
        firstSleepTime
            .appending(days: numberOfDays - 1)!
            .addingTimeInterval(dailyShift * Double(numberOfDays))
            .addingTimeInterval(sleepDuration)
    }
    
    static let defaultDateIntervalFormula: DateIntervalFormula = { firstSleepTime, duration in
        let nightDate = calendar.date(bySettingHour: 00, minute: 0, second: 0, of: firstSleepTime)!
        let noonDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: firstSleepTime)!
        let startDay = firstSleepTime > nightDate && firstSleepTime < noonDate
            ? firstSleepTime.noon.appending(days: -1)!
            : firstSleepTime.noon
        let endDay = startDay.appending(days: duration)!
        return DateInterval(start: startDay, end: endDay)
    }
}