//
//  DatesManager.swift
//  Rise
//
//  Created by Владимир Королев on 03/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class DatesConverter {
    class func formatDateToHHmm(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
