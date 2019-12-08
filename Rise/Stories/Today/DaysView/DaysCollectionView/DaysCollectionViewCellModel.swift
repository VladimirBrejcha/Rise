//
//  DaysCollectionViewCellModel.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DaysCollectionViewCellModel {
    let day: Date
    var sunTime: (sunrise: String, sunset: String)?
    var planTime: (wake: String, sleep: String)?
    var sunErrorMessage: String?
    var planErrorMessage: String?
    
    mutating func update(sunTime: DailySunTime) {
        self.sunTime = (sunrise: DatesConverter.formatDateToHHmm(date: sunTime.sunrise),
                        sunset: DatesConverter.formatDateToHHmm(date: sunTime.sunset))
        sunErrorMessage = nil
    }
    
    mutating func update(planTime: DailyPlanTime) {
        self.planTime = (wake: DatesConverter.formatDateToHHmm(date: planTime.wake),
                         sleep: DatesConverter.formatDateToHHmm(date: planTime.sleep))
        planErrorMessage = nil
    }
}
