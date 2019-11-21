//
//  RiseLocation+CoreDataProperties.swift
//  Rise
//
//  Created by Владимир Королев on 05.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//
//

import Foundation
import CoreData

extension RiseLocation {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RiseLocation> {
        return NSFetchRequest<RiseLocation>(entityName: String(describing: RiseLocation.self))
    }

    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
}
