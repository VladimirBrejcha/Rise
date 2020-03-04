//
//  UpdatePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol UpdatePlan {
    @discardableResult func execute(with plan: PersonalPlan) -> Bool
}

final class UpdatePlanUseCase: UpdatePlan {
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    @discardableResult func execute(with plan: PersonalPlan) -> Bool {
        planRepository.update(personalPlan: plan)
    }
}
