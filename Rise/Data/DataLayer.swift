//
//  DataLayer.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum DataLayer {
    static let sunTimeRepository: SunTimeRepository = SunTimeRepositoryImpl(
        DataSources.sunTimeLocalDataSource,
        DataSources.sunTimeRemoteDataSource
    )
    static let locationRepository: LocationRepository = DefaultLocationRepository(
        DataSources.locationLocalDataSource,
        DataSources.locationRemoteDataSource
    )
    static let scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl(
        DataSources.scheduleLocalDataSource
    )
    static let userData: DefaultUserData = .init()
}

fileprivate struct DataSources {
    static let scheduleLocalDataSource: ScheduleLocalDataSource = ScheduleCoreDataService(
        containerName: "ScheduleData"
    )
    static let locationLocalDataSource: LocationLocalDataSource = DefaultLocationLocalDataSource(
        containerName: "LocationData"
    )
    static let locationRemoteDataSource: LocationRemoteDataSource = DefaultLocationRemoteDataSource()
    static let sunTimeLocalDataSource: SunTimeLocalDataSource = SunTimeCoreDataService(
        containerName: "SunTimeData"
    )
    static let sunTimeRemoteDataSource: SunTimeRemoteDataSource = SunTimeAPIServiceImpl()
}
