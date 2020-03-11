//
//  Formulas.swift
//  Rise
//
//  Created by Владимир Королев on 09.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias DailyShiftFormula = (Date, Double, Int) -> Int
typealias ToSleepTimeFormula = (Date, Int, Int) -> Date
typealias WakeUpTimeFormula = (Date, Int, Int, Double) -> Date
typealias DateIntervalFormula = (Date, Int) -> DateInterval

struct Formulas {
    static let defaultDailyShiftFormula: DailyShiftFormula = { firstSleepTime, sleepDurationSec, duration in
        let adjustedSleepTime = firstSleepTime.addingTimeInterval(sleepDurationSec)
        return firstSleepTime > adjustedSleepTime
            ? -(Int(from: firstSleepTime.timeIntervalSince(adjustedSleepTime)) / duration)
            : Int(from: adjustedSleepTime.timeIntervalSince(firstSleepTime)) / duration
    }
    
    static let defaultToSleepTimeFormula: ToSleepTimeFormula = { firstSleepTime, numberOfDays, dailyShiftMin in
        firstSleepTime
            .appending(days: numberOfDays)
            .addingTimeInterval(TimeInterval(dailyShiftMin * 60 * numberOfDays))
    }
    
    static let defaultWakeUpTimeFormula: WakeUpTimeFormula = { firstSleepTime, numberOfDays, dailyShiftMin, sleepDuration in
        firstSleepTime
            .appending(days: numberOfDays - 1)
            .addingTimeInterval(TimeInterval(dailyShiftMin * 60 * numberOfDays))
            .addingTimeInterval(sleepDuration)
    }
    
    static let defaultDateIntervalFormula: DateIntervalFormula = { firstSleepTime, duration in
        let nightDate = calendar.date(bySettingHour: 00, minute: 0, second: 0, of: firstSleepTime)!
        let noonDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: firstSleepTime)!
        let startDay = firstSleepTime > nightDate && firstSleepTime < noonDate
            ? firstSleepTime.noon.appending(days: -1)
            : firstSleepTime.noon
        let endDay = startDay.appending(days: duration)
        return DateInterval(start: startDay, end: endDay)
    }
}
