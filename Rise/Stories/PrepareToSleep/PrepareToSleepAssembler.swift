//
//  PrepareToSleepAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PrepareToSleepAssembler: StoryAssembler {
    typealias View = PrepareToSleepViewController
    
    func assemble() -> View {
        let controller = Storyboards.sleep.instantiateViewController(of: PrepareToSleepViewController.self)
        controller.output = PrepareToSleepPresenter(view: controller,
                                                    getDailyTime: DomainLayer.getDailyTime)
        return controller
    }
}
