//
//  RiseDailySunTime+CoreDataProperties.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RiseSunTime {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseSunTime> {
        return NSFetchRequest<RiseSunTime>(entityName: String(describing: RiseSunTime.self))
    }
    @NSManaged public var sunrise: Date
    @NSManaged public var sunset: Date
}
