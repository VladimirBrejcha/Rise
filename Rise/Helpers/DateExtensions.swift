//
//  DateExtensions.swift
//  Rise
//
//  Created by Владимир Королев on 22.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

let calendar = Calendar.autoupdatingCurrent

extension Date {
    func appending(days: Int) -> Date? {
        return calendar.date(byAdding: .day, value: days, to: self)
    }
}
