//
//  PersonalPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanAssembler: StoryAssembler {
    typealias View = PersonalPlanViewController
    typealias ViewInput = PersonalPlanViewInput
    typealias ViewOutput = PersonalPlanViewOutput
    
    func assemble() -> PersonalPlanViewController {
        let controller = Storyboard.main.instantiateViewController(of: PersonalPlanViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: PersonalPlanViewInput) -> PersonalPlanViewOutput {
        return PersonalPlanPresenter(
            view: view,
            getPlan: assemble(),
            observePlan: assemble()
        )
    }
    
    private func assemble() -> GetPlan  {
        return GetPlan(repository: DataLayer.personalPlanRepository)
    }
    
    private func assemble() -> ObservePlan {
        return ObservePlan(repository: DataLayer.personalPlanRepository)
    }
}
