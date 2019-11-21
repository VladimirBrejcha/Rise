//
//  locationLocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

fileprivate typealias ObjectType = RiseLocation
fileprivate let containerName = "LocationData"

class LocationLocalDataSource {
    private lazy var container: PersistentContainer<ObjectType> = {
        let container = PersistentContainer<ObjectType>(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("Unable to load persistent stores: \(error)") } }
        return container
    }()
    
    private let builder = LocationModelBuilder()
    
    private var context: NSManagedObjectContext { return container.viewContext }
    private let entityName = String(describing: ObjectType.self)
    
    func requestLocation() -> Result<Location, Error> {
        switch container.fetch() {
        case .success (let location):
            return .success(builder.buildModel(from: location[0]))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @discardableResult func create(location: Location) -> Bool {
        let locationObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ObjectType
        builder.update(object: locationObject, with: location)
        return container.saveContext()
    }
    
    func deleteAll() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        }
        catch {
            return false
        }
    }
}
