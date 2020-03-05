//
//  PersonalPlanLocalDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

protocol PersonalPlanDataSource {
    func get() throws -> PersonalPlan
    func save(plan: PersonalPlan) throws
    func update(plan: PersonalPlan) throws
    func deleteAll() throws
}

final class DefaultPersonalPlanLocalDataSource: LocalDataSource<RisePersonalPlan>, PersonalPlanDataSource {
    func get() throws -> PersonalPlan {
        do {
            let fetchResult = try container.fetch()
            if fetchResult.isEmpty {
                throw RiseError.errorNoDataFound()
            }
            return buildModel(from: fetchResult[0])
        } catch (let error) {
            throw error
        }
    }
    
    func save(plan: PersonalPlan) throws {
        let planObject = insertObject()
        update(object: planObject, with: plan)
        try container.saveContext()
    }
    
    func update(plan: PersonalPlan) throws {
        do {
            let fetchResult = try container.fetch()
            if fetchResult.isEmpty {
                throw RiseError.errorNoDataFound()
            }
            update(object: fetchResult[0], with: plan)
            try container.saveContext()
        } catch (let error) {
            throw error
        }
    }
    
    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try context.save()
    }
    
    // MARK: - Private -
    private func buildModel(from object: RisePersonalPlan) -> PersonalPlan {
        return PersonalPlan(
            paused: object.paused,
            dailyShiftMin: Int(object.dailyShiftMin),
            dateInterval: DateInterval(start: object.planStartDay, end: object.planEndDay),
            sleepDurationSec: object.sleepDurationSec,
            wakeTime: object.wakeTime,
            latestConfirmedDay: object.latestConfirmedDay,
            daysMissed: Int(object.daysMissed)
        )
    }
    
    private func update(object: RisePersonalPlan, with model: PersonalPlan) {
        object.paused = model.paused
        object.dailyShiftMin = Int64(model.dailyShiftMin)
        object.planStartDay = model.dateInterval.start
        object.planEndDay = model.dateInterval.end
        object.wakeTime = model.wakeTime
        object.sleepDurationSec = model.sleepDurationSec
        object.latestConfirmedDay = model.latestConfirmedDay
        object.daysMissed = Int64(model.daysMissed)
    }
}
