//
//  PersonalPlanRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanRepository {
    private let local = PersonalPlanLocalDataSource()
    
    func requestPersonalPlan(completion: @escaping (Result<PersonalPlan, Error>) -> Void) {
        completion(local.requestPersonalPlan())
    }
    
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool {
        local.update(personalPlan: personalPlan)
    }
    
    @discardableResult func create(personalPlan: PersonalPlan) -> Bool {
        local.create(personalPlan: personalPlan)
    }
    
    @discardableResult func removePersonalPlan() -> Bool {
        local.deleteAll()
    }
}
