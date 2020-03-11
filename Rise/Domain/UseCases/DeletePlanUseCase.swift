//
//  DeletePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol DeletePlan {
    func execute() throws
}

final class DeletePlanUseCase: DeletePlan {
    private let planRepository: RisePlanRepository
    
    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() throws {
        try planRepository.removeAll()
    }
}
