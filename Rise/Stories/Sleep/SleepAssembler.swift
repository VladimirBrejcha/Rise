//
//  SleepAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 13.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SleepAssembler {
    func assemble(alarm time: Date) -> SleepViewController {
        let controller = Storyboards.sleep.instantiateViewController(of: SleepViewController.self)
        controller.alarmTime = time
        return controller
    }
}
