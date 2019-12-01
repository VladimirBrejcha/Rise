//
//  PersonalPlanHelper.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter
}()

extension PersonalPlan {
    var sleepDurationHours: String { return (self.sleepDuration / 3600).stringWithoutZeroFraction }
    var wakeUpAt: String { return dateFormatter.string(from: self.finalWakeTime) }
    var willSleep: String { return dateFormatter.string(from: self.finalSleepTime) }
    var planDurationDays: Int { return Int(self.planDuration / 24 / 60) }
}

extension Double {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
