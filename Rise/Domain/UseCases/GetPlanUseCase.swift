//
//  GetPlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetPlan {
    func execute() throws -> RisePlan
}

final class GetPlanUseCase: GetPlan {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() throws -> RisePlan {
        try planRepository.get()
    }
}
