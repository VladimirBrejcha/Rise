//
//  ConfirmationAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 07.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class ConfirmationAssembler: StoryAssembler {
    typealias View = ConfirmationViewController
    typealias ViewInput = ConfirmationViewInput
    typealias ViewOutput = ConfirmationViewOutput
    
    func assemble() -> ConfirmationViewController {
        let controller = Storyboard.popUp.instantiateViewController(of: ConfirmationViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: ConfirmationViewInput) -> ConfirmationViewOutput {
        return ConfirmationPresenter(view: view,
                                     getPlan: assemble(),
                                     updatePlan: assemble())
    }
    
    private func assemble() -> GetPlan {
        return GetPlan(planRepository: DataLayer.personalPlanRepository)
    }
    
    private func assemble() -> UpdatePlan {
        return UpdatePlan(planRepository: DataLayer.personalPlanRepository)
    }
}
