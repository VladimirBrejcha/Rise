//
//  Formulas.swift
//  Rise
//
//  Created by Владимир Королев on 09.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias DailyShiftFormula = (Date, Double, Int) -> Int
typealias DateIntervalFormula = (Date, Int) -> DateInterval

struct Formulas {
    static let defaultDailyShiftFormula: DailyShiftFormula = { firstSleepTime, sleepDurationSec, duration in
        let adjustedSleepTime = firstSleepTime.addingTimeInterval(sleepDurationSec)
        return firstSleepTime > adjustedSleepTime
            ? -(firstSleepTime.timeIntervalSince(adjustedSleepTime).toMinutes() / duration)
            : adjustedSleepTime.timeIntervalSince(firstSleepTime).toMinutes() / duration
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
