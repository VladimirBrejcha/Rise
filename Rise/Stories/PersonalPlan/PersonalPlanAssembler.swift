//
//  PersonalPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class PersonalPlanAssembler {
    func assemble() -> PersonalPlanViewController {
        let controller = Storyboard.main.instantiateViewController(of: PersonalPlanViewController.self)
        controller.getPlan = DomainLayer.getPlan
        controller.pausePlan = DomainLayer.pausePlan
        controller.observePlan = DomainLayer.observePlan
        return controller
    }
}
