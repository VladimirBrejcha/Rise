//
//  RiseDailySunTime+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RiseDailySunTime {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseDailySunTime> {
        return NSFetchRequest<RiseDailySunTime>(entityName: String(describing: RiseDailySunTime.self))
    }

    @NSManaged public var day: Date
    @NSManaged public var sunrise: Date
    @NSManaged public var sunset: Date
}
