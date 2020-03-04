//
//  PersonalPlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias PlanObserver = (PersonalPlan?) -> Void

final class DefaultPersonalPlanRepository: PersonalPlanRepository {    
    private let local = PersonalPlanLocalDataSource()
    private var observers: [UUID: PlanObserver] = [:]
    
    func add(observer: @escaping PlanObserver, with uuid: UUID) {
        observers[uuid] = observer
    }
    
    func removeObserver(with uuid: UUID) {
        observers.removeValue(forKey: uuid)
    }
    
    func get() -> Result<PersonalPlan, Error> {
        local.requestPersonalPlan()
    }
    
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool {
        let result = local.update(personalPlan: personalPlan)
        
        if result {
            if !observers.isEmpty {
                observers.forEach { observer in
                    observer.value(personalPlan)
                }
            }
        }
        
        return result
    }
    
    @discardableResult func save(personalPlan: PersonalPlan) -> Bool {
        let result = local.create(personalPlan: personalPlan)
        
        if result {
            if !observers.isEmpty {
                observers.forEach { observer in
                    observer.value(personalPlan)
                }
            }
        }
        
        return result
    }
    
    @discardableResult func removeAll() -> Bool {
        let result = local.deleteAll()
        
        if result {
            if !observers.isEmpty {
                observers.forEach { observer in
                    observer.value(nil)
                }
            }
        }
        
        return result
    }
}
