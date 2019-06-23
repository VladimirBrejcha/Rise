//
//  PersonalTimeCalculator.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import RealmSwift

struct PersonalTimeCalculator {
    
    // MARK: Properties
    let wakeUp: Date
    let sleepDuration: Int
    let wentSleepTime: Date
    let duration: Int
    
    fileprivate var result: Int {
        guard let neededTimeToGoSleep = Calendar.current.date(byAdding: .minute,
                                                              value: -sleepDuration,
                                                              to: wakeUp) else { fatalError("date doesnt exist") }
        
        let timeBetweenNeededSleepAndActualSleep = Int(-neededTimeToGoSleep.timeIntervalSince(wentSleepTime) / 60)
        
        return timeBetweenNeededSleepAndActualSleep > 1440
            ? (timeBetweenNeededSleepAndActualSleep - 1440) / duration
            : timeBetweenNeededSleepAndActualSleep / duration
    }
    
    // MARK: LifeCycle
    init(wakeUp: Date, sleepDuration: Int, wentSleepTime: Date, duration: Int) {
        self.wakeUp = wakeUp
        self.sleepDuration = sleepDuration
        self.wentSleepTime = wentSleepTime
        self.duration = duration
        let calculatedPlan = CalculatedPlan()
        calculatedPlan.days = duration
        calculatedPlan.minutesPerDay = result
        let manager = PersonalTimeManager(calculatedPlan: calculatedPlan)
        manager.save()
    }
    
}

class CalculatedPlan: Object {
    @objc dynamic var days: Int = 0
    @objc dynamic var minutesPerDay: Int = 0
}

struct PersonalTimeManager {
    private let realm = try! Realm()
    let calculatedPlan: CalculatedPlan
    
    func save() {
        do {
            try realm.write {
                realm.add(calculatedPlan)
            }
        } catch {
            print("error saving plan \(error)")
        }
    }
}
