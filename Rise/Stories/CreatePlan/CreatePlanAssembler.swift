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
    typealias ViewInput = CreatePlanViewInput
    typealias ViewOutput = CreatePlanViewOutput
    
    func assemble() -> CreatePlanViewController {
        let controller = Storyboard.setupPlan.instantiateViewController(of: CreatePlanViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: CreatePlanViewInput) -> CreatePlanViewOutput {
        let presenter = CreatePlanPresenter(view: view, createPlan: assemble())
        presenter.stories = assemble(presenter: presenter)
        return presenter
    }
    
    private func assemble(presenter: CreatePlanPresenter) -> [Story] {
        return [.welcomeCreatePlan,
                .sleepDurationCreatePlan(sleepDurationOutput: presenter.sleepDurationValueChanged(_:)),
                .wakeUpTimeCreatePlan(wakeUpTimeOutput: presenter.wakeUpTimeValueChanged(_:)),
                .planDurationCreatePlan(planDurationOutput: presenter.planDurationValueChanged(_:)),
                .wentSleepCreatePlan(wentSleepOutput: presenter.lastTimeWentSleepValueChanged(_:)),
                .planCreatedSetupPlan]
    }
    
    private func assemble() -> CreatePlan {
        return CreatePlan(planRepository: DataLayer.personalPlanRepository)
    }
}
