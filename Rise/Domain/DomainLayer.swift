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
        GetPlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var makePlan: MakePlan {
        MakePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository,
                        dailyShiftFormula: Formulas.defaultDailyShiftFormula,
                        dateIntervalFormula: Formulas.defaultDateIntervalFormula)
    }
    static var updatePlan: UpdatePlan {
        UpdatePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var deletePlan: DeletePlan {
        DeletePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var observePlan: ObservePlan {
        ObservePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var getSunTime: GetSunTime {
        GetSunTimeUseCase(with: DataLayer.locationRepository, and: DataLayer.sunTimeRepository)
    }
    static var getDailyTime: GetDailyTime {
        GetDailyTimeUseCase(planRepository: DataLayer.defaultRisePlanRepository,
                            toSleepTimeFormula: Formulas.defaultToSleepTimeFormula,
                            wakeUpTimeFormula: Formulas.defaultWakeUpTimeFormula)
    }
    static var pausePlan: PausePlan {
        PausePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var confirmPlan: ConfirmPlan {
        ConfirmPlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
    static var reshedulePlan: ReshedulePlan {
        ReshedulePlanUseCase(planRepository: DataLayer.defaultRisePlanRepository)
    }
}