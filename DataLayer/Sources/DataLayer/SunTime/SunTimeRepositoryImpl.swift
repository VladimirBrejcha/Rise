import Core
import CoreLocation
import Foundation

final class SunTimeRepositoryImpl: SunTimeRepository {

    var cached: Cache<[Core.SunTime]>?

    private let localDataSource: SunTimeLocalDataSource

    private let weatherService: WeatherService

    init(_ localDataSource: SunTimeLocalDataSource,
         _ weatherService: WeatherService
    ) {
        self.localDataSource = localDataSource
        self.weatherService = weatherService
    }

    private func apiRequest(_ dates: [Date], location: CLLocation) async throws -> [SunTime] {
        let interval = DateInterval(start: dates[0], end: dates[dates.count - 1].addingTimeInterval(days: 1))
        return try await weatherService.requestSunTimes(
            for: interval,
            location: location
        )
    }

    func requestSunTimes(dates: [Date], location: CLLocation) async -> SunTimesResult {
        if dates.isEmpty {
            return .success([])
        }
        do {
            let localResult = try localDataSource.getSunTimes(for: dates)
            if (localResult.count == dates.count) {
                log(.info, "found stored sunTimes: \(localResult)")
                return .success(localResult)
            }

            let missedDates: [Date] = dates.filter { date in
                !localResult.contains { sunTime in
                    calendar.isDate(sunTime.sunrise, inSameDayAs: date)
                }
            }

            do {
                let remoteResult = try await apiRequest(missedDates, location: location)
                try? localDataSource.save(sunTimes: remoteResult)
                deleteAllOutdated()
                cached = Cache(items: remoteResult)
                return .success(localResult + remoteResult)
            } catch let error {
                log(.error, "getting remote sunTimes failed: \(error.localizedDescription)")
                return .failure(SunTimeError.networkError(underlyingError: error))
            }

        } catch (let error) {
            log(.error, "getting local sunTimes failed: \(error.localizedDescription)")
            do {
                let remoteResult = try await apiRequest(dates, location: location)
                try? localDataSource.save(sunTimes: remoteResult)
                deleteAllOutdated()
                cached = Cache(items: remoteResult)
                return .success(remoteResult)
            } catch let error {
                log(.error, "getting remote sunTimes failed: \(error.localizedDescription)")
                return .failure(SunTimeError.networkError(underlyingError: error))
            }
        }
    }

    func deleteAllOutdated() {
        log(.info)
        cached = nil

        do {
            try localDataSource.delete(before: Date().addingTimeInterval(days: -3))
        } catch (let error) {
            assertionFailure(error.localizedDescription)
            log(.error, "deleting error: \(error.localizedDescription)")
        }
    }

    func deleteAll() {
        log(.info)

        do {
            try localDataSource.deleteAll()
            cached = nil
        } catch (let error) {
            assertionFailure(error.localizedDescription)
            log(.error, "deleting error: \(error.localizedDescription)")
        }
    }
}
