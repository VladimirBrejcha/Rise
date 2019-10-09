//
//  DataBaseManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

struct CalculatedPlan {
    var minutesOfSleep: Int
    var days: Int
    var minutesPerDay: Int
}

fileprivate let planEntityName = "PersonalPlan"

class CoreDataManager {
    
    private var managedContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    var currentPlan: PersonalPlanModel? {
        guard let object = persistentContainer.fetch() else { return nil }
        return buildPlanModel(from: object)
    }
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "PersonalPlanData")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("Unable to load persistent stores: \(error)") } }
        return container
    }()
    
    func createObject(_ model: PersonalPlanModel) {
        buildCoreDataObject(from: model)
        persistentContainer.saveContext()
    }
    
    func updateObject(with model: PersonalPlanModel) {
        guard let object = persistentContainer.fetch() else { fatalError() }
        updateCoreDataObject(object, with: model)
        persistentContainer.saveContext()
    }
    
    private func buildCoreDataObject(from model: PersonalPlanModel) {
        let personalPlan = NSEntityDescription.insertNewObject(forEntityName: planEntityName,
                                                               into: managedContext) as! RisePersonalPlan
        updateCoreDataObject(personalPlan, with: model)
    }
    
    private func updateCoreDataObject(_ object: RisePersonalPlan, with model: PersonalPlanModel) {
        object.endDate = model.planEndDate
        object.startDate = model.planStartDate
        object.planDuration = model.planDuration
        object.planStrartSleepTime = model.planStartSleepTime
        object.sleepDuration = model.sleepDurationSec
        object.sleepTime = model.finalSleepTime
        object.wakeUpTime = model.finalWakeUpTime
    }
    
    private func buildPlanModel(from object: RisePersonalPlan) -> PersonalPlanModel {
        return PersonalPlanModel(planStartSleepTime: object.planStrartSleepTime, finalWakeUpTime: object.wakeUpTime,
                                 finalSleepTime: object.sleepTime, sleepDurationSec: object.sleepDuration,
                                 planStartDate: object.sleepTime, planEndDate: object.endDate,
                                 planDuration: object.planDuration)
    }
}

class PersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func fetch() -> RisePersonalPlan? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: planEntityName)
        
        do {
            let fetchedResult = try viewContext.fetch(fetchRequest) as! [RisePersonalPlan]
            return fetchedResult.first
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension RisePersonalPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RisePersonalPlan> {
        return NSFetchRequest<RisePersonalPlan>(entityName: planEntityName)
    }

    @NSManaged public var endDate: Date
    @NSManaged public var planDuration: Double
    @NSManaged public var planStrartSleepTime: Date
    @NSManaged public var sleepDuration: Double
    @NSManaged public var sleepTime: Date
    @NSManaged public var startDate: Date
    @NSManaged public var wakeUpTime: Date

}
