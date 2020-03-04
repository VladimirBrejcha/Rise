//
//  GetPlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetPla {
    <#requirements#>
}

final class GetPlanUseCase: UseCase {
    typealias InputValue = Void
    typealias CompletionHandler = Void
    typealias OutputValue = PersonalPlan?
    
    private let planRepository: DefaultPersonalPlanRepository
    
    required init(planRepository: DefaultPersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(_ requestValue: Void = (), completion: Void = ()) -> PersonalPlan? {
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
