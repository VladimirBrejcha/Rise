//
//  PersonalPlanHelper.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanHelper {
    private var plan: PersonalPlanModel
    var sleepDurationHours: Double { return plan.sleepDurationSec / 3600 }
    var wakeUpAt: String { return dateFormatter.string(from: plan.finalWakeUpTime) }
    var willSleep: String { return dateFormatter.string(from: plan.finalSleepTime) }
    var planDurationDays: Int { return Int(plan.planDuration / 24 / 60 / 60) }
    
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    init(plan: PersonalPlanModel) { self.plan = plan }
    
}
