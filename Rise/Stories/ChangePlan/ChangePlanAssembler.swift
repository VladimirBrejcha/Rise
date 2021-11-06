//
//  ChangePlanAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 02.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class ChangePlanAssembler {    
    func assemble() -> ChangePlanViewController {
        let controller = Storyboard.changePlan.instantiateViewController(of: ChangePlanViewController.self)
        controller.getSchedule = DomainLayer.getSchedule
        controller.updateSchedule = DomainLayer.updateSchedule
        controller.deleteSchedule = DomainLayer.deleteSchedule
        return controller
    }
}
