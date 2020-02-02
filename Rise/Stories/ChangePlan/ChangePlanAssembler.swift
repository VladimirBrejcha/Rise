//
//  ChangePlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 02.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ChangePlanAssembler: StoryAssembler {
    typealias View = ChangePlanViewController
    typealias ViewInput = ChangePlanViewInput
    typealias ViewOutput = ChangePlanViewOutput
    
    func assemble() -> ChangePlanViewController {
        let controller = Storyboard.changePlan.instantiateViewController(of: ChangePlanViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: ChangePlanViewInput) -> ChangePlanViewOutput {
        let presenter = ChangePlanPresenter(view: view, updatePlan: assemble())
        return presenter
    }
    
    private func assemble() -> UpdatePlan {
        return UpdatePlan(planRepository: DataLayer.personalPlanRepository)
    }
}
