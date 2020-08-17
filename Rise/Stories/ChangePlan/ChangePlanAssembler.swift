//
//  ChangePlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 02.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class ChangePlanAssembler {    
    func assemble() -> ChangePlanViewController {
        let controller = Storyboard.changePlan.instantiateViewController(of: ChangePlanViewController.self)
        controller.getPlan = DomainLayer.getPlan
        controller.updatePlan = DomainLayer.updatePlan
        controller.deletePlan = DomainLayer.deletePlan
        return controller
    }
}
