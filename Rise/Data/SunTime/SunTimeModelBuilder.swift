//
//  SunTimeModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct SunTimeModelBuilder {
    func buildModel(from object: RiseSunTime) -> SunTime {
        return SunTime(sunrise: object.sunrise, sunset: object.sunset)
    }
    
    func update(object: RiseSunTime, with model: SunTime) {
        object.sunrise = model.sunrise
        object.sunset = model.sunset
    }
}
