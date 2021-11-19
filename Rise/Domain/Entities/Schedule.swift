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
        case low = 0
        case normal = 1
        case high = 2

        var description: String {
            switch self {
            case .low:
                return "Low"
            case .normal:
                return "Normal"
            case .high:
                return "High"
            }
        }
        
        var index: Int {
            Int(rawValue)
        }
    }
}
