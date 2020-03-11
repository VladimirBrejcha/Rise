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
        let controller = Storyboard.main.instantiateViewController(of: TodayStoryViewController.self)
        controller.output = TodayStoryPresenter(view: controller,
                                                getSunTime: DomainLayer.getSunTime,
                                                getPlan: DomainLayer.getPlan,
                                                observePlan: DomainLayer.observePlan,
                                                getDailyTime: DomainLayer.getDailyTime,
                                                confirmPlan: DomainLayer.confirmPlan)
        return controller
    }
}
