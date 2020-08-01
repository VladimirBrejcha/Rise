//
//  SettingsPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SettingsPresenter: SettingsViewOutput {
    private weak var view: SettingsViewInput?
    
    required init(view: SettingsViewInput) {
        self.view = view
    }
}
