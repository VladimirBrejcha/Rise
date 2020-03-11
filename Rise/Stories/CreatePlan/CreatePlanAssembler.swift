//
//  SetupPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class CreatePlanAssembler: StoryAssembler {
    typealias View = CreatePlanViewController
    
    func assemble() -> CreatePlanViewController {
        let controller = Storyboard.setupPlan.instantiateViewController(of: CreatePlanViewController.self)
        let presenter = CreatePlanPresenter(view: controller, makePlan: DomainLayer.makePlan)
        controller.output = presenter
        presenter.stories = [.welcomeCreatePlan,
                             .sleepDurationCreatePlan(sleepDurationOutput: presenter.sleepDurationValueChanged(_:)),
                             .wakeUpTimeCreatePlan(wakeUpTimeOutput: presenter.wakeUpTimeValueChanged(_:)),
                             .planDurationCreatePlan(planDurationOutput: presenter.planDurationValueChanged(_:)),
                             .wentSleepCreatePlan(wentSleepOutput: presenter.lastTimeWentSleepValueChanged(_:)),
                             .planCreatedSetupPlan]
        return controller
    }
}
