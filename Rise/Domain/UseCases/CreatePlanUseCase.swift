//
//  CreatePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol CreatePlan {
    @discardableResult func execute(with plan: PersonalPlan) -> Bool
}

final class CreatePlanUseCase: CreatePlan {
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    @discardableResult func execute(with plan: PersonalPlan) -> Bool {
        planRepository.save(personalPlan: plan)
    }
}
