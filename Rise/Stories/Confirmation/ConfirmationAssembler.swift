//
//  ConfirmationAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class ConfirmationAssembler {    
    func assemble() -> ConfirmationViewController {
        let controller = Storyboard.confirmation.instantiateViewController(
            of: ConfirmationViewController.self
        )
//        controller.getPlan = DomainLayer.getPlan
//        controller.confirmPlan = DomainLayer.confirmPlan
//        controller.getDailyTime = DomainLayer.getDailyTime
//        controller.reshedulePlan = DomainLayer.reshedulePlan
        return controller
    }
}
