//
//  TodayAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class TodayAssembler {
    func assemble() -> TodayViewController {
        let controller = Storyboard.main.instantiateViewController(of: TodayViewController.self)
        controller.getPlan = DomainLayer.getPlan
        controller.observePlan = DomainLayer.observePlan
        controller.getDailyTime = DomainLayer.getDailyTime
        controller.confirmPlan = DomainLayer.confirmPlan
        return controller
    }
}
