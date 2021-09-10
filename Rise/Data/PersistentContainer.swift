//
//  PersistentContainer.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

final class PersistentContainer<ObjectType: NSManagedObject>: NSPersistentContainer {
    func fetch(with predicate: NSPredicate? = nil) throws -> [ObjectType] {
        let entityName = String(describing: ObjectType.self)
        let fetchRequest = NSFetchRequest<ObjectType>(entityName: entityName)
        fetchRequest.predicate = predicate
        return try viewContext.fetch(fetchRequest)
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) throws {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        try context.save()
    }
}
