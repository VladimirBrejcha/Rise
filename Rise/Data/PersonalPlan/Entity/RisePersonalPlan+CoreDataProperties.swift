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

    @NSManaged public var paused: Bool
    @NSManaged public var dailyShiftMin: Int64
    @NSManaged public var planStartDay: Date
    @NSManaged public var planEndDay: Date
    @NSManaged public var wakeTime: Date
    @NSManaged public var sleepDurationSec: Double
    @NSManaged public var latestConfirmedDay: Date
}
