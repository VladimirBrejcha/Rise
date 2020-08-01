//
//  TodayAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class TodayAssembler: StoryAssembler {
    typealias View = TodayStoryViewController
    
    func assemble() -> TodayStoryViewController {
        let controller = Storyboards.main.instantiateViewController(
            of: TodayStoryViewController.self
        )
        controller.getSunTime = DomainLayer.getSunTime
        controller.getPlan = DomainLayer.getPlan
        controller.observePlan = DomainLayer.observePlan
        controller.getDailyTime = DomainLayer.getDailyTime
        controller.confirmPlan = DomainLayer.confirmPlan
        return controller
    }
}
