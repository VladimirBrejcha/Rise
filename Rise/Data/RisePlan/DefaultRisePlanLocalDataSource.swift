//
//  PersonalPlanLocalDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreData

protocol PersonalPlanLocalDataSource {
    func get() throws -> RisePlan
    func save(plan: RisePlan) throws
    func update(plan: RisePlan) throws
    func deleteAll() throws
}

final class DefaultRisePlanLocalDataSource: LocalDataSource<RisePlanObject>, PersonalPlanLocalDataSource {
    func get() throws -> RisePlan { // TODO
        do {
            let fetchResult = try container.fetch()
            if fetchResult.isEmpty {
                throw PlanError.planDoesNotExist
            }
            return buildModel(from: fetchResult[0])
        } catch (let error) {
            throw error
        }
    }
    
    func save(plan: RisePlan) throws {
        let planObject = insertObject()
        update(object: planObject, with: plan)
        try container.saveContext()
    }
    
    func update(plan: RisePlan) throws { // TODO
        do {
            let fetchResult = try container.fetch()
            if fetchResult.isEmpty {
                throw NetworkError.noDataReceived
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
    private func buildModel(from object: RisePlanObject) -> RisePlan {
        return RisePlan(
            dateInterval: DateInterval(start: object.planStartDay, end: object.planEndDay),
            firstSleepTime: object.firstSleepTime,
            finalWakeUpTime: object.finalWakeUpTime,
            sleepDurationSec: object.sleepDurationSec,
            dailyShiftMin: Int(object.dailyShiftMin),
            latestConfirmedDay: object.latestConfirmedDay,
            daysMissed: Int(object.daysMissed),
            paused: object.paused
        )
    }
    
    private func update(object: RisePlanObject, with model: RisePlan) {
        object.paused = model.paused
        object.dailyShiftMin = Int64(model.dailyShiftMin)
        object.planStartDay = model.dateInterval.start
        object.planEndDay = model.dateInterval.end
        object.firstSleepTime = model.firstSleepTime
        object.finalWakeUpTime = model.finalWakeUpTime
        object.sleepDurationSec = model.sleepDurationSec
        object.latestConfirmedDay = model.latestConfirmedDay
        object.daysMissed = Int64(model.daysMissed)
    }
}
