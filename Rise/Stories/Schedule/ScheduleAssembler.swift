//
//  ScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class ScheduleAssembler {
    func assemble() -> ScheduleViewController {
        let controller = Storyboard.main.instantiateViewController(of: ScheduleViewController.self)
        controller.getSchedule = DomainLayer.getSchedule
        controller.pauseSchedule = DomainLayer.pauseSchedule
        return controller
    }
}
