//
//  ObservePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ObservePlanUseCase: UseCase {
    typealias InputValue = (PersonalPlan?) -> Void
    typealias CompletionHandler = Void
    typealias OutputValue = Void
    
    private let planRepository: DefaultPersonalPlanRepository
    
    required init(planRepository: DefaultPersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(_ requestValue: @escaping (PersonalPlan?) -> Void, completion: Void = ()) {
        planRepository.personalPlanUpdateOutput.append(requestValue)
    }
}
