//
//  RiseSunTime+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RiseSunTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseSunTime> {
        return NSFetchRequest<RiseSunTime>(entityName: "SunTime")
    }

    @NSManaged public var sunrise: Date
    @NSManaged public var sunset: Date
    @NSManaged public var day: Date

}
