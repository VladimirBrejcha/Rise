//
//  GetPlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetPlan {
    func execute() throws -> PersonalPlan
}

final class GetPlanUseCase: GetPlan {
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() throws -> PersonalPlan {
        try planRepository.get()
    }
}
