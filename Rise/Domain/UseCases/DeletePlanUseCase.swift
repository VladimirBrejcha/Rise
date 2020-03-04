//
//  DeletePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol DeletePlan {
    @discardableResult func execute() -> Bool
}

final class DeletePlanUseCase: DeletePlan {
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() -> Bool {
        planRepository.removeAll()
    }
}
