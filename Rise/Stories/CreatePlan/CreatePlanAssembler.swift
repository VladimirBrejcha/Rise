//
//  SetupPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class CreatePlanAssembler {
    func assemble() -> CreatePlanViewController {
        let controller = Storyboard.setupPlan.instantiateViewController(of: CreatePlanViewController.self)
        controller.makePlan = DomainLayer.makePlan
        controller.stories = [
            .welcomeCreatePlan,
            .sleepDurationCreatePlan(
                sleepDurationOutput: controller.sleepDurationValueChanged(_:),
                sleepDurationDataSource: controller.choosenSleepDuration
            ),
            .wakeUpTimeCreatePlan(
                wakeUpTimeOutput: controller.wakeUpTimeValueChanged(_:),
                wakeUpTimeDataSource: controller.choosenWakeUpTime
            ),
            .planDurationCreatePlan(
                planDurationOutput: controller.planDurationValueChanged(_:),
                planDurationDataSource: controller.choosenPlanDuration
            ),
            .wentSleepCreatePlan(
                wentSleepOutput: controller.lastTimeWentSleepValueChanged(_:),
                wentSleepDataSource: controller.choosenLastTimeWentSleep
            ),
            .planCreatedSetupPlan
        ]
        return controller
    }
}
