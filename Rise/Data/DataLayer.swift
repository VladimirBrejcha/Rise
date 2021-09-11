//
//  DataLayer.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DataLayer {
    static let defaultRisePlanRepository: RisePlanRepository = DefaultRisePlanRepository(
        DataSources.planLocalDataSource
    )
    static let sunTimeRepository: SunTimeRepository = DefaultSunTimeRepository(
        DataSources.sunTimeLocalDataSource,
        DataSources.sunTimeRemoteDataSource
    )
    static let locationRepository: LocationRepository = DefaultLocationRepository(
        DataSources.locationLocalDataSource,
        DataSources.locationRemoteDataSource
    )
    static let userData: DefaultUserData = .init()
}

fileprivate struct DataSources {
    static let planLocalDataSource: PersonalPlanLocalDataSource = DefaultRisePlanLocalDataSource(
        containerName: "RisePlanData"
    )
    static let locationLocalDataSource: LocationLocalDataSource = DefaultLocationLocalDataSource(
        containerName: "LocationData"
    )
    static let locationRemoteDataSource: LocationRemoteDataSource = DefaultLocationRemoteDataSource()
    static let sunTimeLocalDataSource: SunTimeLocalDataSource = DefaultSunTimeLocalDataSource(
        containerName: "SunTimeData"
    )
    static let sunTimeRemoteDataSource: SunTimeRemoteDataSource = DefaultSunTimeRemoteDataSource()
}
