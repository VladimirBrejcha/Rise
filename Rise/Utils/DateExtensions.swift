//
//  DateExtensions.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

let calendar = Calendar.autoupdatingCurrent

enum NoonedDay: String, CaseIterable {
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
    
    var timeIntervalSinceNow: TimeInterval {
        timeIntervalSince(Date())
    }
    
    var zeroSeconds: Date? {
        calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self))
    }
    
    func changeDayStoringTime(to day: Day) -> Date {
        changeDayStoringTime(to: day.date)
    }
    
    func changeDayStoringTime(to date: Date) -> Date {
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: self)
        guard
            let newDate = calendar.date(
                from: DateComponents(
                    year: dateComponents.year,
                    month: dateComponents.month,
                    day: dateComponents.day,
                    hour: timeComponents.hour,
                    minute: timeComponents.minute,
                    second: timeComponents.second
                )
            ) else {
                fatalError()
        }
        return newDate
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
            : hours == 0
                ? "\(minutes) minutes"
                : "\(hours)h \(minutes)m"
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
