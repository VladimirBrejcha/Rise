import Foundation
import Core
import CoreLocation

public typealias SunTimesResult = Result<[SunTime], SunTimeError>

public protocol SunTimeRepository {
  func requestSunTimes(
    dates: [Date],
    location: CLLocation,
    completion: @escaping (SunTimesResult) -> Void
  )
  func deleteAll()
}
