//
//  SunTimePersistentContainer.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

class PersistentContainer<ObjectType: NSManagedObject>: NSPersistentContainer {
    func fetch(with predicate: NSPredicate? = nil) -> Result<[ObjectType], Error> {
        let entityName = String(describing: ObjectType.self)
        let fetchRequest = NSFetchRequest<ObjectType>(entityName: entityName)
        do {
            fetchRequest.predicate = predicate
            let objects = try viewContext.fetch(fetchRequest)
            if objects.isEmpty { return .failure(RiseError.errorNoDataFound()) }
            return .success(objects)
        }
        catch { return .failure(error) }
    }
    
    @discardableResult func saveContext(backgroundContext: NSManagedObjectContext? = nil) -> Bool {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return false }
        do {
            try context.save()
            return true
        }
        catch {
            log(error.localizedDescription)
            return false
        }
    }
}
