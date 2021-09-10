//
//  GetPlan.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetPlan {
    func callAsFunction() throws -> RisePlan
}

final class GetPlanUseCase: GetPlan {
    private let planRepository: RisePlanRepository
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func callAsFunction() throws -> RisePlan {
        try planRepository.get()
    }
}
