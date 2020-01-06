//
//  DataLayer.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DataLayer {
    static let personalPlanRepository: PersonalPlanRepository = PersonalPlanRepository()
    static let sunTimeRepository: SunTimeRepository = SunTimeRepository()
    static let locationRepository: LocationRepository = LocationRepository()
}
