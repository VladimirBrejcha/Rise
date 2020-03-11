//
//  PersonalPlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias PlanObserver = (RisePlan?) -> Void

final class DefaultRisePlanRepository: PersonalPlanRepository {    
    private let localDataSource: PersonalPlanLocalDataSource
    private var observers: [UUID: PlanObserver] = [:]
    
    required init(with localDataSource: PersonalPlanLocalDataSource) {
        self.localDataSource = localDataSource
    }
    
    func add(observer: @escaping PlanObserver, with uuid: UUID) {
        observers[uuid] = observer
    }
    
    func removeObserver(with uuid: UUID) {
        observers.removeValue(forKey: uuid)
    }
    
    func get() throws -> RisePlan {
        try localDataSource.get()
    }
    
    func update(plan: RisePlan) throws {
        try localDataSource.update(plan: plan)
        
        if !observers.isEmpty {
            observers.forEach { observer in
                observer.value(plan)
            }
        }
    }
    
    func save(plan: RisePlan) throws {
        try localDataSource.save(plan: plan)
        
        if !observers.isEmpty {
            observers.forEach { observer in
                observer.value(plan)
            }
        }
    }
    
    func removeAll() throws {
        try localDataSource.deleteAll()
        
        if !observers.isEmpty {
            observers.forEach { observer in
                observer.value(nil)
            }
        }
    }
}
