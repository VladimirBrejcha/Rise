//
//  RiseDailyPlanTime+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RiseDailyPlanTime {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseDailyPlanTime> {
        return NSFetchRequest<RiseDailyPlanTime>(entityName: String(describing: Self.self))
    }

    @NSManaged public var day: Date
    @NSManaged public var wake: Date
    @NSManaged public var sleep: Date
}
