//
//  PrepareToSleepAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class PrepareToSleepAssembler {
    func assemble() -> PrepareToSleepViewController {
        let controller = Storyboard.sleep.instantiateViewController(of: PrepareToSleepViewController.self)
        controller.getPlan = DomainLayer.getPlan
        controller.getDailyTime = DomainLayer.getDailyTime
        return controller
    }
}
