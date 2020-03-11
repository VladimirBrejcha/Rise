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
        guard let date = Date().appending(days: numberOfDaysFromToday)?.noon
            else {
                log(.error, with: "Failed to append \(numberOfDaysFromToday) days to today, returning today")
                return Day.today.date
        }
        return date
    }
    
    private var numberOfDaysFromToday: Int {
        switch self {
        case .yesterday: return -1
        case .today: return 0
        case .tomorrow: return 1
        }
    }
}

extension DateInterval {
    var durationDays: Int {
        calendar.dateComponents([.day],
                                from: self.start.noon,
                                to: self.end.noon).day!
    }
}

extension Date {
    var HHmmString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    var noon: Date {
        calendar.date(bySettingHour: 12, minute: 00, second: 00, of: self)!
    }
    
    func appending(days: Int) -> Date? {
        if days == 0 { return self }
        return calendar.date(byAdding: .day, value: days, to: self)
    }
}

extension Int {
    init(from seconds: Double) {
        self = Int(seconds / 60)
    }
    var HHmmString: String {
        let hours = self / 60
        let minutes = self % 60
        
        return minutes == 0
        ? "\(hours) hours"
        : "\(hours) h \(minutes) m"
    }
}

extension Double {
    init(from minutes: Int) {
        self = Double(minutes * 60)
    }
    
    var HHmmString: String {
        Int(from: self).HHmmString
    }
}
