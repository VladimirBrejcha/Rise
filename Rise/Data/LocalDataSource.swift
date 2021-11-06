//
//  LocalDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import CoreData

class LocalDataSource<Object: NSManagedObject> {

    lazy var container: PersistentContainer<Object> = {
        let container = PersistentContainer<Object>(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    private let containerName: String

    var context: NSManagedObjectContext { container.viewContext }
    let entityName: String = String(describing: Object.self)
    
    func insertObject() -> Object {
        NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Object
    }

    func deleteAll() throws {
        log(.info)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
    
    required init(containerName: String) {
        self.containerName = containerName
    }
}
