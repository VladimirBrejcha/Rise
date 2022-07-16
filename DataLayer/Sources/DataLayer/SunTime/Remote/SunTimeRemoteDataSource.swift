import Foundation
import Core

typealias SunTimeRemoteResult = Result<[SunTime], NetworkError>

protocol SunTimeRemoteDataSource {
  func requestSunTimes(
    for dates: [Date],
    location: Location,
    completion: @escaping (SunTimeRemoteResult) -> Void
  )
}
