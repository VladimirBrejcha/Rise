//
//  SettingsPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SettingsPresenter: SettingsViewOutput {
    weak var view: SettingsViewInput?
    
    required init(view: SettingsViewInput) {
        self.view = view
    }
}
