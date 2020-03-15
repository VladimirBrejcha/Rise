//
//  SleepPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 13.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SleepPresenter: SleepViewOutput {
    private weak var view: SleepViewInput?
    
    required init(view: SleepViewInput) {
        self.view = view
    }
}
