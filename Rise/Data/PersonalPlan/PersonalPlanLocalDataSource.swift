//
//  PersonalPlanLocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

fileprivate typealias ObjectType = RisePersonalPlan
fileprivate let containerName = "PersonalPlanData"

class PersonalPlanLocalDataSource {
    private lazy var container: PersistentContainer<ObjectType> = {
        let container = PersistentContainer<ObjectType>(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("Unable to load persistent stores: \(error)") } }
        return container
    }()
    
    private let builder = PersonalPlanModelBuilder()
    
    private var context: NSManagedObjectContext { return container.viewContext }
    private let entityName = String(describing: ObjectType.self)
    
    func requestPersonalPlan() -> Result<PersonalPlan, Error> {
        switch container.fetch() {
        case .success (let personalPlan):
            return .success(builder.buildModel(from: personalPlan[0]))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @discardableResult func create(personalPlan: PersonalPlan) -> Bool {
        let personalPlanObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ObjectType
        builder.update(object: personalPlanObject, with: personalPlan)
        return container.saveContext()
    }
    
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool {
        switch container.fetch() {
        case .success (let personalPlanObject):
            builder.update(object: personalPlanObject[0], with: personalPlan)
            return container.saveContext()
        case .failure(let error):
            log(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult func deleteAll() -> Bool {
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