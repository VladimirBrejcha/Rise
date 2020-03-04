//
//  GetPlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetPlan {
    func execute() -> PersonalPlan?
}

final class GetPlanUseCase: GetPlan {
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() -> PersonalPlan? {
        let result = planRepository.get()
        switch result {
        case .success(let plan):
            return plan
        case .failure(let error):
            log(.error, with: error.localizedDescription)
            return nil
        }
    }
}
