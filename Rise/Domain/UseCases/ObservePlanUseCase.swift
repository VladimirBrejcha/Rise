//
//  ObservePlan.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ObservePlan {
    func observe(_ observer: @escaping PlanObserver)
    func cancel()
}

final class ObservePlanUseCase: ObservePlan {
    private let planRepository: RisePlanRepository
    
    private let observerUUID = UUID()
    
    init(_ planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    deinit {
        cancel()
    }
    
    func observe(_ observer: @escaping PlanObserver) {
        planRepository.add(observer: observer, with: observerUUID)
    }
    
    func cancel() {
        planRepository.removeObserver(with: observerUUID)
    }
}
