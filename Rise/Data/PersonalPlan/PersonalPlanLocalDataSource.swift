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
fileprivate typealias DailyTimeObjectType = RiseDailyPlanTime
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
    private let planEntityName = String(describing: ObjectType.self)
    private let planTimeEntityName = String(describing: DailyTimeObjectType.self)
    
    func requestPersonalPlan() -> Result<PersonalPlan, Error> {
        switch container.fetch() {
        case .success (let personalPlan):
            return .success(builder.buildModel(from: personalPlan[0]))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @discardableResult func create(personalPlan: PersonalPlan) -> Bool {
        let personalPlanObject = NSEntityDescription.insertNewObject(forEntityName: planEntityName,
                                                                     into: context) as! ObjectType
        let planTimeObjects = personalPlan.dailyTimes.map { create(planTime: $0) }
        builder.update(object: personalPlanObject, with: personalPlan, and: planTimeObjects)
        return container.saveContext()
    }
    
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool {
        switch container.fetch() {
        case .success (let personalPlanObject):
            let planTimeObjects = personalPlan.dailyTimes.map { create(planTime: $0) }
            builder.update(object: personalPlanObject[0], with: personalPlan, and: planTimeObjects)
            return container.saveContext()
        case .failure(let error):
            log(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult func deleteAll() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: planEntityName)
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
    
    private func create(planTime: DailyPlanTime) -> DailyTimeObjectType {
        let dailyPlanTimeObject = NSEntityDescription.insertNewObject(forEntityName: planTimeEntityName,
                                                                      into: context) as! DailyTimeObjectType
        builder.update(object: dailyPlanTimeObject, with: planTime)
        return dailyPlanTimeObject
    }
}
