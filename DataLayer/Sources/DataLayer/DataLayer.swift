import Foundation

public enum DataLayer {
    public static let sunTimeRepository: SunTimeRepository = SunTimeRepositoryImpl(
        DataSources.sunTimeLocalDataSource,
        DataSources.weatherService
    )
    public static let locationRepository: LocationRepository = DefaultLocationRepository(
        DataSources.locationDeviceDataSource
    )
    public static let scheduleRepository: ScheduleRepository = ScheduleRepositoryImpl(
        DataSources.scheduleLocalDataSource
    )
    public static let userData: DefaultUserData = .init()
}

fileprivate struct DataSources {
    static let scheduleLocalDataSource: ScheduleLocalDataSource = ScheduleCoreDataService(
        containerName: "ScheduleData"
    )
    static let locationDeviceDataSource: LocationDeviceDataSource = LocationDeviceDataSourceImpl()
    static let sunTimeLocalDataSource: SunTimeLocalDataSource = SunTimeCoreDataService(
        containerName: "SunTimeData"
    )

    static let weatherService: WeatherService = WKServiceImpl()
}
