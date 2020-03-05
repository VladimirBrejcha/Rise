//
//  DataLayer.swift
//  Rise
//
//  Created by Владимир Королев on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DataLayer {
    static let personalPlanRepository: PersonalPlanRepository = DefaultPersonalPlanRepository(with: DataSources.planLocalDataSource)
    static let sunTimeRepository: SunTimeRepository = DefaultSunTimeRepository(with: DataSources.sunTimeLocalDataSource,
                                                                               and: DataSources.sunTimeRemoteDataSource)
    static let locationRepository: LocationRepository = DefaultLocationRepository(with: DataSources.locationLocalDataSource,
                                                                                  and: DataSources.locationRemoteDataSource)
}

fileprivate struct DataSources {
    static let planLocalDataSource: PersonalPlanLocalDataSource = DefaultPersonalPlanLocalDataSource(with:  "PersonalPlanData")
    static let locationLocalDataSource: LocationLocalDataSource = DefaultLocationLocalDataSource(with: "LocationData")
    static let locationRemoteDataSource: LocationRemoteDataSource = DefaultLocationRemoteDataSource()
    static let sunTimeLocalDataSource: SunTimeLocalDataSource = DefaultSunTimeLocalDataSource(with: "SunTimeData")
    static let sunTimeRemoteDataSource: SunTimeRemoteDataSource = DefaultSunTimeRemoteDataSource()
}
