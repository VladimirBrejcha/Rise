//
//  RisePlanObject+CoreDataProperties.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RisePlanObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RisePlanObject> {
        return NSFetchRequest<RisePlanObject>(entityName: String(describing: RisePlanObject.self))
    }

    @NSManaged public var paused: Bool
    @NSManaged public var dailyShiftMin: Int64
    @NSManaged public var planStartDay: Date
    @NSManaged public var planEndDay: Date
    @NSManaged public var finalWakeUpTime: Date
    @NSManaged public var sleepDurationSec: Double
    @NSManaged public var latestConfirmedDay: Date
    @NSManaged public var daysMissed: Int64
    @NSManaged public var firstSleepTime: Date
}
