//
//  PrepareToSleepAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class PrepareToSleepAssembler {
    func assemble() -> PrepareToSleepViewController {
        let controller = Storyboard.sleep.instantiateViewController(of: PrepareToSleepViewController.self)
        controller.getSchedule = DomainLayer.getSchedule
        controller.preferredWakeUpTime = DomainLayer.preferredWakeUpTime
        controller.suggestKeepAppOpened = DomainLayer.suggestKeepAppUpened
        return controller
    }
}
