import Foundation

public enum DataLayer {
  public static let sunTimeRepository: SunTimeRepository = SunTimeRepositoryImpl(
    DataSources.sunTimeLocalDataSource,
    DataSources.sunTimeRemoteDataSource
  )
  public static let locationRepository: LocationRepository = DefaultLocationRepository(
    DataSources.locationLocalDataSource,
    DataSources.locationRemoteDataSource
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
  static let locationLocalDataSource: LocationLocalDataSource = DefaultLocationLocalDataSource(
    containerName: "LocationData"
  )
  static let locationRemoteDataSource: LocationDeviceDataSource = LocationDeviceDataSourceImpl()
  static let sunTimeLocalDataSource: SunTimeLocalDataSource = SunTimeCoreDataService(
    containerName: "SunTimeData"
  )
  static let sunTimeRemoteDataSource: SunTimeRemoteDataSource = SunTimeAPIServiceImpl()
}
