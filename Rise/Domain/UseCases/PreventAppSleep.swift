//
//  PreventAppSleep.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol PreventAppSleep {
    func callAsFunction(_ prevent: Bool)
}

final class PreventAppSleepImpl: PreventAppSleep {
    func callAsFunction(_ prevent: Bool) {
        UIApplication.shared.isIdleTimerDisabled = prevent
    }
}
