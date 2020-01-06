//
//  SetupPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SetupPlanAssembler: StoryAssembler {
    typealias View = SetupPlanViewController
    typealias ViewInput = SetupPlanViewInput
    typealias ViewOutput = SetupPlanViewOutput
    
    func assemble() -> SetupPlanViewController {
        let controller = Storyboard.setupPlan.instantiateViewController(of: SetupPlanViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: SetupPlanViewInput) -> SetupPlanViewOutput {
        let presenter = SetupPlanPresenter(view: view, createPlan: assemble())
        presenter.stories = assemble(presenter: presenter)
        return presenter
    }
    
    private func assemble(presenter: SetupPlanPresenter) -> [Story] {
        return [.welcomeSetupPlan,
                .sleepDurationSetupPlan(sleepDurationOutput: presenter.sleepDurationValueChanged(_:)),
                .wakeUpTimeSetupPlan(wakeUpTimeOutput: presenter.wakeUpTimeValueChanged(_:)),
                .planDurationSetupPlan(planDurationOutput: presenter.planDurationValueChanged(_:)),
                .wentSleepSetupPlan(wentSleepOutput: presenter.lastTimeWentSleepValueChanged(_:)),
                .planCreatedSetupPlan]
    }
    
    private func assemble() -> CreatePlan {
        return CreatePlan(planRepository: DataLayer.personalPlanRepository)
    }
}
