//
//  DateExtensions.swift
//  Rise
//
//  Created by Владимир Королев on 22.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

let calendar = Calendar.autoupdatingCurrent

enum NoonedDay {
    case yesterday
    case today
    case tomorrow
    
    var date: Date {
        Date().appending(days: numberOfDaysFromToday).noon
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
        calendar.dateComponents([.day], from: start.noon, to: end.noon).day ?? 0
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
    
    func appending(days: Int) -> Date {
        days == 0
            ? self
            : calendar.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    func addingTimeInterval(minutes timeInterval: Int) -> Date {
        addingTimeInterval(timeInterval.toSeconds())
    }
}

extension Int {
    func toSeconds() -> Double {
        Double(self * 60)
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
    func toMinutes() -> Int {
        Int(self / 60)
    }
    
    var HHmmString: String {
        self.toMinutes().HHmmString
    }
}
