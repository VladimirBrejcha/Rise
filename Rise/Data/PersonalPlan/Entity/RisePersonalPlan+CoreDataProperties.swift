//
//  RisePersonalPlan+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RisePersonalPlan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RisePersonalPlan> {
        return NSFetchRequest<RisePersonalPlan>(entityName: String(describing: RisePersonalPlan.self))
    }

    @NSManaged public var state: PersonalPlanState
    @NSManaged public var planStartDay: Date
    @NSManaged public var planDuration: Int64
    @NSManaged public var finalSleepTime: Date
    @NSManaged public var finalWakeTime: Date
    @NSManaged public var sleepDuration: Double
    @NSManaged public var latestConfirmedDay: Date
    @NSManaged public var daliyPlanTime: NSSet
}

// MARK: Generated accessors for daliyPlanTime
extension RisePersonalPlan {

    @objc(addDaliyPlanTimeObject:)
    @NSManaged public func addToDaliyPlanTime(_ value: RiseDailyPlanTime)

    @objc(removeDaliyPlanTimeObject:)
    @NSManaged public func removeFromDaliyPlanTime(_ value: RiseDailyPlanTime)

    @objc(addDaliyPlanTime:)
    @NSManaged public func addToDaliyPlanTime(_ values: NSSet)

    @objc(removeDaliyPlanTime:)
    @NSManaged public func removeFromDaliyPlanTime(_ values: NSSet)
}
