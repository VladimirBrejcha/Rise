//
//  DateExtensions.swift
//  Rise
//
//  Created by Владимир Королев on 22.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

let calendar = Calendar.autoupdatingCurrent

enum Day {
    case yesterday
    case today
    case tomorrow
    
    var date: Date {
        guard let date = Date().appending(days: numberOfDaysFromToday)
            else {
                log("Failed to append \(numberOfDaysFromToday) days to today")
                return Date()
        }
        return date
    }
    
    private var numberOfDaysFromToday: Int {
        switch self {
        case .yesterday: return -1
        case .today: return 0
        case .tomorrow: return -1
        }
    }
}

extension Date {
    func appending(days: Int) -> Date? {
        if days == 0 { return self }
        return calendar.date(byAdding: .day, value: days, to: self)
    }
}

extension Date {
    var HHmmString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
