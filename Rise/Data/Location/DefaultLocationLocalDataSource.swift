//
//  locationLocalDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

protocol LocationLocalDataSource {
    func get() throws -> Location?
    func save(location: Location) throws
    func deleteAll() throws
}

final class DefaultLocationLocalDataSource: LocalDataSource<RiseLocation>, LocationLocalDataSource {
    func get() throws -> Location? {
        let fetchResult = try container.fetch()
        if fetchResult.isEmpty { return nil }
        return buildModel(from: fetchResult[0])
    }
    
    func save(location: Location) throws {
        let locationObject = insertObject()
        update(object: locationObject, with: location)
        try container.saveContext()
    }
    
    // MARK: - Private -
    private func buildModel(from object: RiseLocation) -> Location {
        return Location(latitude: object.latitude, longitude: object.longitude)
    }
    
    private func update(object: RiseLocation, with model: Location) {
        object.latitude = model.latitude
        object.longitude = model.longitude
    }
}
