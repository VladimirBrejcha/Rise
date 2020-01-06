//
//  ObservePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ObservePlan: UseCase {
    typealias InputValue = (PersonalPlan?) -> Void
    typealias CompletionHandler = Void
    typealias OutputValue = Void
    
    private let planRepository: PersonalPlanRepository
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute(_ requestValue: @escaping (PersonalPlan?) -> Void, completion: Void) -> Void {
        planRepository.personalPlanUpdateOutput = requestValue
    }
}
