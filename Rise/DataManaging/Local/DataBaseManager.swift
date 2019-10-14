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
fileprivate let sunTimeEntityName = "SunTime"

class CoreDataManager: SunTimeDataSource { // TODO: - Location is not used in requestSunForecast
    private var managedContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    var currentPlan: PersonalPlanModel? {
        guard let object = persistentContainer.fetchPersonalPlan() else { return nil }
        return buildPlanModel(from: object)
    }
    
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "PersonalPlanData")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("Unable to load persistent stores: \(error)") } }
        return container
    }()

    // MARK: - SunTimeDataSource
    func requestSunForecast(for numberOfDays: Int, at startingDate: Date, with location: LocationModel,
                            completion: @escaping (Result<[SunTimeModel], Error>) -> Void) {
        
        var returnArray: [SunTimeModel] = []
        
        let group = DispatchGroup()

        DispatchQueue.concurrentPerform(iterations: numberOfDays) { dayNumber in
            group.enter()
            
            guard let date = Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: startingDate)
                else {
                    completion(.failure(RiseError.errorCantFormatDate()))
                    group.leave()
                    return
            }
            let fetchResult = persistentContainer.fetchSunTime(for: date)
            
            if case .failure (let error) = fetchResult { completion(.failure(error)) }
            else if case .success (let result) = fetchResult { returnArray.append(buildSunTimeModel(from: result)) }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if returnArray.isEmpty { completion(.failure(RiseError.errorNoDataReceived())) }
            else { completion(.success(returnArray)) }
        }
        
    }
    
    func createSunObject(_ model: SunTimeModel) {
        buildSunTimeObject(from: model)
        persistentContainer.saveContext()
    }
    
    func createObject(_ model: PersonalPlanModel) {
        buildCoreDataObject(from: model)
        persistentContainer.saveContext()
    }
    
    func updateObject(with model: PersonalPlanModel) {
        guard let object = persistentContainer.fetchPersonalPlan() else { fatalError() }
        updateCoreDataObject(object, with: model)
        persistentContainer.saveContext()
    }
    
    private func buildSunTimeObject(from model: SunTimeModel) {
        let sunTimeModel = NSEntityDescription.insertNewObject(forEntityName: sunTimeEntityName,
                                                               into: managedContext) as! RiseSunTime
        updateSunObject(sunTimeModel, with: model)
    }
    
    private func buildCoreDataObject(from model: PersonalPlanModel) {
        let personalPlan = NSEntityDescription.insertNewObject(forEntityName: planEntityName,
                                                               into: managedContext) as! RisePersonalPlan
        updateCoreDataObject(personalPlan, with: model)
    }
    
    private func updateSunObject(_ object: RiseSunTime, with model: SunTimeModel) {
        object.day = model.day
        object.sunrise = model.sunrise
        object.sunset = model.sunset
        print("## objectday \(object.day)")
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
    
    private func buildSunTimeModel(from object: RiseSunTime) -> SunTimeModel {
        return SunTimeModel(day: object.day, sunrise: object.sunrise, sunset: object.sunset)
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
    
    func fetchPersonalPlan() -> RisePersonalPlan? {
        let fetchRequest: NSFetchRequest<RisePersonalPlan> = RisePersonalPlan.fetchRequest()
        
        do {
            let fetchedResult = try viewContext.fetch(fetchRequest)
            return fetchedResult.first
        } catch {
            print("Failed to fetch: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchSunTime(for day: Date) -> Result<RiseSunTime, Error> {
        let fetchRequest: NSFetchRequest<RiseSunTime> = RiseSunTime.fetchRequest()
        do {
            print("## day \(day)")
            fetchRequest.predicate = makeDayPredicate(with: day)
            let fetchedResult = try viewContext.fetch(fetchRequest)
            guard let result = fetchedResult.first else { return .failure(RiseError.errorNoDataFound()) }
            return .success(result) }
        catch { return .failure(error) }
    }
    
    func makeDayPredicate(with date: Date) -> NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "day >= %@ AND day =< %@", argumentArray: [startDate!, endDate!])
    }
    
}
