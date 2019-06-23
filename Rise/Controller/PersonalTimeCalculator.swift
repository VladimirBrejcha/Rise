//
//  PersonalTimeCalculator.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalTimeCalculator {
    
    // MARK: Properties
    let wakeUp: Date
    let sleepDuration: Int
    let wentSleepTime: Date
    let duration: Int
    
    private var result: Int {
        guard let neededTimeToGoSleep = Calendar.current.date(byAdding: .minute,
                                                              value: -sleepDuration,
                                                              to: wakeUp) else { fatalError("date doesnt exist") }
        
        let timeBetweenNeededSleepAndActualSleep = Int(-neededTimeToGoSleep.timeIntervalSince(wentSleepTime) / 60)
        
        return timeBetweenNeededSleepAndActualSleep > 1440
            ? (timeBetweenNeededSleepAndActualSleep - 1440) / duration
            : timeBetweenNeededSleepAndActualSleep / duration
    }
    
    private var calculatedPlan: CalculatedPlan! {
        let plan = CalculatedPlan()
        plan.days = duration
        plan.minutesPerDay = result
        return plan
    }
    
    private var manager: DataBaseManager! {
        return DataBaseManager(calculatedPlan: calculatedPlan)
    }
    
    // MARK: LifeCycle
    init(wakeUp: Date, sleepDuration: Int, wentSleepTime: Date, duration: Int) {
        self.wakeUp = wakeUp
        self.sleepDuration = sleepDuration
        self.wentSleepTime = wentSleepTime
        self.duration = duration
        manager.save()
    }
    
}
