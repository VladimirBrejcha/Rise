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
    var personalPlanUpdateOutput: ((PersonalPlan?) -> Void)?
    
    func requestPersonalPlan() -> Result<PersonalPlan, Error> {
        return local.requestPersonalPlan()
    }
    
    @discardableResult func update(personalPlan: PersonalPlan) -> Bool {
        let result = local.update(personalPlan: personalPlan)
        
        if result {
            personalPlanUpdateOutput?(personalPlan)
        }
        
        return result
    }
    
    @discardableResult func create(personalPlan: PersonalPlan) -> Bool {
        let result = local.create(personalPlan: personalPlan)
        
        if result {
            personalPlanUpdateOutput?(personalPlan)
        }
        
        return result
    }
    
    @discardableResult func removePersonalPlan() -> Bool {
        let result = local.deleteAll()
        
        if result {
            personalPlanUpdateOutput?(nil)
        }
        
        return result
    }
}
