//
//  SettingsAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SettingsAssembler: StoryAssembler {
    typealias View = SettingsViewController
    
    func assemble() -> SettingsViewController {
        let controller = Storyboards.settings.instantiateViewController(of: SettingsViewController.self)
        controller.output = SettingsPresenter(view: controller)
        return controller
    }
}
