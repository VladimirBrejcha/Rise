//
//  ObservePlan.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ObservePlan {
    func observe(_ observer: @escaping PlanObserver)
    func cancel()
}

final class ObservePlanUseCase: ObservePlan {
    private let planRepository: PersonalPlanRepository
    
    private let observerUUID = UUID()
    
    required init(planRepository: PersonalPlanRepository) {
        self.planRepository = planRepository
    }
    
    func observe(_ observer: @escaping PlanObserver) {
        planRepository.add(observer: observer, with: observerUUID)
    }
    
    func cancel() {
        planRepository.removeObserver(with: observerUUID)
    }
}
