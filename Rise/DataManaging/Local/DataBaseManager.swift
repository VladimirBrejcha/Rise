//
//  DataBaseManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

fileprivate let planEntityName = "PersonalPlan"
fileprivate let sunTimeEntityName = "SunTime"

class CoreDataManager: SunTimeDataSource {
    private var managedContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
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
    
    func createSunTimeObject(with model: SunTimeModel) {
        buildSunTimeObject(from: model)
        persistentContainer.saveContext()
    }
    
    private func buildSunTimeObject(from model: SunTimeModel) {
        let sunTimeModel = NSEntityDescription.insertNewObject(forEntityName: sunTimeEntityName,
                                                               into: managedContext) as! RiseSunTime
        updateSunObject(sunTimeModel, with: model)
    }
    
    private func updateSunObject(_ object: RiseSunTime, with model: SunTimeModel) {
        object.day = model.day
        object.sunrise = model.sunrise
        object.sunset = model.sunset
    }
    
    private func buildSunTimeModel(from object: RiseSunTime) -> SunTimeModel {
        return SunTimeModel(day: object.day, sunrise: object.sunrise, sunset: object.sunset)
    }
    
    // MARK: - Personal Plan
    var currentPlan: PersonalPlanModel? {
        let result = persistentContainer.fetchPersonalPlan()
        if case .failure (let error) = result {
            print(error)
            return nil
        }
        else if case .success (let object) = result { return buildPlanModel(from: object) }
        else { return nil }
    }
    
    func createPersonalPlanObject(with model: PersonalPlanModel) {
        buildPersonalPlanObject(with: model)
        persistentContainer.saveContext()
    }
    
    private func buildPersonalPlanObject(with model: PersonalPlanModel) {
        let result = persistentContainer.fetchPersonalPlan()
        var personalPlan: RisePersonalPlan!
        if case .failure (let error) = result {
            print(error)
            personalPlan = NSEntityDescription.insertNewObject(forEntityName: planEntityName,
                                                               into: managedContext) as? RisePersonalPlan
        }
        else if case .success (let object) = result { personalPlan = object }
        updatePersonalPlanObject(personalPlan, with: model)
    }
    
    private func updatePersonalPlanObject(_ object: RisePersonalPlan, with model: PersonalPlanModel) {
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

