//
//  SunTimeModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct SunTimeModelBuilder {
    func buildModel(from object: RiseDailySunTime) -> DailySunTime {
        return DailySunTime(day: object.day, sunrise: object.sunrise, sunset: object.sunset)
    }
    
    func update(object: RiseDailySunTime, with model: DailySunTime) {
        object.day = model.day
        object.sunrise = model.sunrise
        object.sunset = model.sunset
    }
}
