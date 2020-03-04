//
//  DomainLayer.swift
//  Rise
//
//  Created by Владимир Королев on 02.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class DomainLayer {
    static var getPlan: GetPlan {
        GetPlanUseCase(planRepository: DataLayer.personalPlanRepository)
    }
    static var createPlan: CreatePlan {
        CreatePlanUseCase(planRepository: DataLayer.personalPlanRepository)
    }
    static var updatePlan: UpdatePlan {
        UpdatePlanUseCase(planRepository: DataLayer.personalPlanRepository)
    }
    static var deletePlan: DeletePlan {
        DeletePlanUseCase(planRepository: DataLayer.personalPlanRepository)
    }
    static var observePlan: ObservePlan {
        ObservePlanUseCase(planRepository: DataLayer.personalPlanRepository)
    }
    static var getSunTime: GetSunTime {
        GetSunTimeUseCase(with: DataLayer.locationRepository, and: DataLayer.sunTimeRepository)
    }
}
