//
//  ConfirmPlanUseCase.swift
//  Rise
//
//  Created by Владимир Королев on 10.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ConfirmPlan {
    func execute() throws
    func checkIfConfirmed() throws -> Bool
}

final class ConfirmPlanUseCase: ConfirmPlan {
    private let planRepository: RisePlanRepository

    required init(planRepository: RisePlanRepository) {
        self.planRepository = planRepository
    }
    
    func execute() throws {
        let plan = try planRepository.get()
        let confirmedPlan = RisePlan(dateInterval: plan.dateInterval,
                                     firstSleepTime: plan.firstSleepTime,
                                     finalWakeUpTime: plan.finalWakeUpTime,
                                     sleepDurationSec: plan.sleepDurationSec,
                                     dailyShiftMin: plan.dailyShiftMin,
                                     latestConfirmedDay: Date().noon,
                                     daysMissed: plan.daysMissed,
                                     paused: plan.paused)
        try planRepository.update(plan: confirmedPlan)
    }
    
    func checkIfConfirmed() throws -> Bool {
        let plan = try planRepository.get()
        if plan.paused { return true }
        return plan.latestConfirmedDay >= NoonedDay.yesterday.date
    }
}
