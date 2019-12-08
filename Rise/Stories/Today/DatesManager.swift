//
//  DatesManager.swift
//  Rise
//
//  Created by Владимир Королев on 03/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct SunModel {
    var sunrise: Date
    var sunset: Date
}

class DatesConverter {
    
    class func formatDateToHHmm(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    class func buildDate(timestamp: Int) -> Date {
        return Date(timeIntervalSince1970: Double(timestamp))
    }
    
    class func buildTimestamp(date: Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    class func buildDate(day: SegmentedControlViewButtons) -> Date {
        switch day {
        case .yesterday:
            guard let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { fatalError("couldnt build yesterday date") }
            return yesterdayDate
        case .today:
            return Date()
        case .tomorrow:
            guard let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else { fatalError("couldnt build tomorrow date") }
            return tomorrowDate
        }
    }
    
}
