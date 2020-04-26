//
//  PersonalPlanAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PersonalPlanAssembler: StoryAssembler {
    typealias View = PersonalPlanViewController
    
    func assemble() -> PersonalPlanViewController {
        let controller = Storyboards.main.instantiateViewController(of: PersonalPlanViewController.self)
        controller.output = PersonalPlanPresenter(
            view: controller,
            getPlan: DomainLayer.getPlan,
            pausePlan: DomainLayer.pausePlan,
            observePlan: DomainLayer.observePlan
        )
        return controller
    }
}
