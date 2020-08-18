//
//  SettingsAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class SettingsAssembler {
    func assemble() -> SettingsViewController {
        let controller = Storyboard.settings.instantiateViewController(of: SettingsViewController.self)
        return controller
    }
}
