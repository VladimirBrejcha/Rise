//
//  SetupPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class CreatePlanAssembler {
    func assemble() -> CreatePlanViewController {
        let controller = Storyboard.setupPlan.instantiateViewController(of: CreatePlanViewController.self)
        controller.makePlan = DomainLayer.makePlan
        controller.stories = [
            .welcomeCreatePlan,
            .sleepDurationCreatePlan(sleepDurationOutput: controller.sleepDurationValueChanged(_:)),
            .wakeUpTimeCreatePlan(wakeUpTimeOutput: controller.wakeUpTimeValueChanged(_:)),
            .planDurationCreatePlan(planDurationOutput: controller.planDurationValueChanged(_:)),
            .wentSleepCreatePlan(wentSleepOutput: controller.lastTimeWentSleepValueChanged(_:)),
            .planCreatedSetupPlan
        ]
        return controller
    }
}
