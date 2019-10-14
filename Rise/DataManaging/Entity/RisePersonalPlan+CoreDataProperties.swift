//
//  RisePersonalPlan+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RisePersonalPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RisePersonalPlan> {
        return NSFetchRequest<RisePersonalPlan>(entityName: "PersonalPlan")
    }

    @NSManaged public var endDate: Date
    @NSManaged public var planDuration: Double
    @NSManaged public var planStrartSleepTime: Date
    @NSManaged public var sleepDuration: Double
    @NSManaged public var sleepTime: Date
    @NSManaged public var startDate: Date
    @NSManaged public var wakeUpTime: Date

}
