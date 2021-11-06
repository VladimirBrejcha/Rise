//
//  Day.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

enum Day {
    case yesterday
    case today
    case tomorrow

    var date: Date {
        Date().addingTimeInterval(minutes: minutesFromToday)
    }

    private var minutesFromToday: Int {
        switch self {
        case .yesterday: return -(24 * 60)
        case .today: return 0
        case .tomorrow: return 24 * 60
        }
    }
}
