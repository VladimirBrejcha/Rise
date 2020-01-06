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
    typealias ViewInput = TodayStoryViewInput
    typealias ViewOutput = TodayStoryViewOutput
    
    func assemble() -> TodayStoryViewController {
        let controller = Storyboard.main.instantiateViewController(of: TodayStoryViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: TodayStoryViewInput) -> TodayStoryViewOutput {
        return TodayStoryPresenter(view: view,
                                   getSunTime: asseble(),
                                   getPlan: asseble(),
                                   observePlan: assemble())
    }
    
    private func asseble() -> GetSunTime {
        return GetSunTime(locationRepository: DataLayer.locationRepository,
                          sunTimeRepository: DataLayer.sunTimeRepository)
    }
    
    private func asseble() -> GetPlan {
        return GetPlan(repository: DataLayer.personalPlanRepository)
    }
    
    private func assemble() -> ObservePlan {
        return ObservePlan(repository: DataLayer.personalPlanRepository)
    }
}
