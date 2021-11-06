//
//  Schedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

struct Schedule: Equatable {
    let sleepDuration: Minute
    let intensity: Intensity
    let toBed: Date
    let wakeUp: Date
    let targetToBed: Date
    let targetWakeUp: Date
}

extension Schedule {
    typealias Minute = Int
}

extension Schedule {
    enum Intensity: Int16 {
        case low
        case normal
        case high
    }
}
