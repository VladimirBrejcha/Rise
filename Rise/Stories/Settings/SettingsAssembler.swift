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
    typealias ViewInput = SettingsViewInput
    typealias ViewOutput = SettingsViewOutput
    
    func assemble() -> SettingsViewController {
        let controller = Storyboard.settings.instantiateViewController(of: SettingsViewController.self)
        controller.output = assemble(view: controller)
        return controller
    }
    
    func assemble(view: SettingsViewInput) -> SettingsViewOutput {
        return SettingsPresenter(view: view)
    }
}
