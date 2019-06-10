//
//  PersonalTimeCalculator.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct PersonalTimeCalculator {
    
    var wakeUp: Date
    var sleepDuration: Int
    var wentSleepTime: Date
    var duration: Int
    
    var result: Int?
    
    init(wakeUp: Date, sleepDuration: Int, wentSleepTime: Date, duration: Int, result: Double? = nil) {
        self.wakeUp = wakeUp
        self.sleepDuration = sleepDuration
        self.wentSleepTime = wentSleepTime
        self.duration = duration
    }
    
    mutating func calculate() {
        
        guard let neededTimeToGoSleep = Calendar.current.date(byAdding: .minute,
                                                              value: -sleepDuration,
                                                              to: wakeUp) else { fatalError("date doesnt exist") }
        
        let timeBetweenNeededSleepAndActualSleep = Int(-neededTimeToGoSleep.timeIntervalSince(wentSleepTime) / 60)
        
        result = timeBetweenNeededSleepAndActualSleep / duration
    }
    
}
