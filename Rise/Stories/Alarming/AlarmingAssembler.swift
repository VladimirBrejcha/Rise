//
//  AlarmingAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class AlarmingAssembler {
    func assemble(alarm time: Date) -> AlarmingViewController {
        let controller = Storyboard.sleep.instantiateViewController(of: AlarmingViewController.self)
        controller.alarmTime = time
        return controller
    }
}
