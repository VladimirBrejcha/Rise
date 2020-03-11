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
    
    func assemble() -> ConfirmationViewController {
        let controller = Storyboard.popUp.instantiateViewController(of: ConfirmationViewController.self)
        controller.output = ConfirmationPresenter(view: controller,
                                                  getPlan: DomainLayer.getPlan,
                                                  confirmPlan: DomainLayer.confirmPlan,
                                                  getDailyTime: DomainLayer.getDailyTime,
                                                  reshedulePlan: DomainLayer.reshedulePlan)
        return controller
    }
}
