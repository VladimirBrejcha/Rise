//
//  SleepAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 13.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SleepAssembler: StoryAssembler {
    typealias View = SleepViewController
    
    func assemble() -> View {
        let controller = Storyboard.sleep.instantiateViewController(of: View.self)
        controller.output = SleepPresenter(view: controller)
        return controller
    }
}
