import Core
import Foundation

final class SunTimeRepositoryImpl: SunTimeRepository {
  private let localDataSource: SunTimeLocalDataSource
  private let remoteDataSource: SunTimeRemoteDataSource
  
  init(_ localDataSource: SunTimeLocalDataSource, _ remoteDataSource: SunTimeRemoteDataSource) {
    self.localDataSource = localDataSource
    self.remoteDataSource = remoteDataSource
  }
  
  func requestSunTimes(
    dates: [Date],
    location: Location,
    completion: @escaping (SunTimesResult) -> Void
  ) {
    do {
      let localResult = try localDataSource.getSunTimes(for: dates)
      
      if (localResult.count == dates.count) {
        log(.info, "found stored sunTimes: \(localResult)")
        completion(.success(localResult))
        return
      }
      
      let missedDates: [Date] = dates.filter { date in
        !localResult.contains { sunTime in
          calendar.isDate(sunTime.sunrise, inSameDayAs: date)
        }
      }
      
      var finalResult: [SunTime] = localResult
      
      remoteDataSource.requestSunTimes(for: missedDates, location: location) { [weak self] result in
        guard let self = self else {
          completion(.failure(SunTimeError.internalError))
          return
        }
        let handledResult = self.handleRemoteRequestResult(result: result)
        if case let .success(remoteResult) = handledResult {
          finalResult.append(contentsOf: remoteResult)
          completion(.success(finalResult))
        }
        if case let .failure(error) = handledResult {
          completion(.failure(error))
        }
      }
      
    } catch (let error) {
      log(.error, "getting local sunTimes failed: \(error.localizedDescription)")
      remoteDataSource.requestSunTimes(for: dates, location: location) { [weak self] result in
        guard let self = self else {
          completion(.failure(SunTimeError.internalError))
          return
        }
        completion(self.handleRemoteRequestResult(result: result))
      }
    }
  }
  
  func deleteAll() {
    log(.info)
    
    do {
      try localDataSource.deleteAll()
    } catch (let error) {
      assertionFailure(error.localizedDescription)
      log(.error, "deleting error: \(error.localizedDescription)")
    }
  }
  
  private func handleRemoteRequestResult(result: SunTimeRemoteResult) -> SunTimesResult {
    switch result {
    case .success(let sunTimes):
      log(.info, "got sunTimes: \(sunTimes)")
      do {
        try localDataSource.save(sunTimes: sunTimes)
      } catch (let error) {
        log(.error, "saving failed \(error.localizedDescription)")
      }
      return .success(sunTimes)
    case .failure(let error):
      log(.error, "got error: \(error.localizedDescription)")
      return .failure(SunTimeError.networkError(underlyingError: error))
    }
  }
}
