import Foundation
import Core

public typealias SunTimesResult = Result<[SunTime], SunTimeError>

public protocol SunTimeRepository {
  func requestSunTimes(
    dates: [Date],
    location: Location,
    completion: @escaping (SunTimesResult) -> Void
  )
  func deleteAll()
}
