//
//  LocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 05.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import CoreData

class LocalDataSource<Object: NSManagedObject> {
    private let containerName: String
    lazy var container: PersistentContainer<Object> = {
        let container = PersistentContainer<Object>(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext { container.viewContext }
    let entityName: String = String(describing: Object.self)
    
    func insertObject() -> Object {
        NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Object
    }
    
    required init(with containerName: String) {
        self.containerName = containerName
    }
}
