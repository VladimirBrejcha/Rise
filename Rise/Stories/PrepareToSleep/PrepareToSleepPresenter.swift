//
//  PrepareToSleepPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PrepareToSleepPresenter: PrepareToSleepViewOutput {
    private weak var view: PrepareToSleepViewInput?
    
    required init(view: PrepareToSleepViewInput) {
        self.view = view
    }
}
