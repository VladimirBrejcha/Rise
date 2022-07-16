import Foundation
import DataLayer

public protocol HasRefreshSunTime {
  var refreshSunTime: RefreshSunTime { get }
}

/*
 * Removes all data for Location and SunTime
 * Fetches new location
 * Next `GetSunTime` call will load refreshed suntimes
 */
public protocol RefreshSunTime {
  func callAsFunction(
    permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
    onSuccess: @escaping() -> Void,
    onFailure: @escaping (Error) -> Void
  )
}

final class RefreshSunTimeImpl: RefreshSunTime {
  private let locationRepository: LocationRepository
  private let sunTimeRepository: SunTimeRepository

  init(_ locationRepository: LocationRepository, _ sunTimeRepository: SunTimeRepository) {
    self.locationRepository = locationRepository
    self.sunTimeRepository = sunTimeRepository
  }

  func callAsFunction(
    permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
    onSuccess: @escaping() -> Void,
    onFailure: @escaping (Error) -> Void
  ) {
    locationRepository.deleteAll()
    sunTimeRepository.deleteAll()
    locationRepository.get(
      permissionRequestProvider: permissionRequestProvider
    ) { result in
      if case .success = result {
        onSuccess()
      }
      if case let .failure(error) = result {
        onFailure(error)
      }
    }
  }
}
