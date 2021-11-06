//
//  DateExtensions.swift
//  Rise
//
//  Created by Vladimir Korolev on 22.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

let calendar = Calendar.autoupdatingCurrent

extension Date {
    var noon: Date {
        calendar.date(bySettingHour: 12, minute: 00, second: 00, of: self)!
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

    func addingTimeInterval(minutes timeInterval: Int) -> Date {
        addingTimeInterval(timeInterval.toSeconds())
    }

    func addingTimeInterval(days: Int) -> Date {
        addingTimeInterval(TimeInterval(days * 24 * 60 * 60))
    }

    var HHmmString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
