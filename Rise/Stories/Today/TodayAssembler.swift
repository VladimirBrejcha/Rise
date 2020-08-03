//
//  TodayAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class TodayAssembler: StoryAssembler {
    typealias View = TodayViewController
    
    func assemble() -> TodayViewController {
        let controller = Storyboards.main.instantiateViewController(
            of: TodayViewController.self
        )
        controller.getSunTime = DomainLayer.getSunTime
        controller.getPlan = DomainLayer.getPlan
        controller.observePlan = DomainLayer.observePlan
        controller.getDailyTime = DomainLayer.getDailyTime
        controller.confirmPlan = DomainLayer.confirmPlan
        return controller
    }
}
