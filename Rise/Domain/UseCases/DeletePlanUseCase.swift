//
//  DeletePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol DeletePlan {
    func callAsFunction() throws
}

final class DeletePlanUseCase: DeletePlan {
    private let planRepository: RisePlanRepository
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func callAsFunction() throws {
        try planRepository.removeAll()
    }
}
