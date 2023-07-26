import Foundation
import Core
import DataLayer
import CoreLocation

public protocol HasGetSunTime {
    var getSunTime: GetSunTime { get }
}

public typealias GetSunTimeCompletion
= (Result<([SunTime], WKLegal), Error>) -> Void

public protocol GetSunTime {
    func callAsFunction(
        numberOfDays: Int,
        since date: Date,
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        completion: @escaping GetSunTimeCompletion
    )
}

final class GetSunTimeImpl: GetSunTime {

    private let locationRepository: LocationRepository
    private let sunTimeRepository: SunTimeRepository

    init(_ locationRepository: LocationRepository,
         _ sunTimeRepository: SunTimeRepository
    ) {
        self.locationRepository = locationRepository
        self.sunTimeRepository = sunTimeRepository
    }

    func callAsFunction(
        numberOfDays: Int,
        since date: Date,
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        completion: @escaping GetSunTimeCompletion
    ) {
        if let cached = sunTimeRepository.cached?.retrieve() { // note: cache dates not validated
            completion(.success(cached))
            return
        }
        let dates = makeDates(since: date, numberOfDays: numberOfDays)
        locationRepository.get(
            permissionRequestProvider: permissionRequestProvider
        ) { [weak self] result in
            if case .success (let location) = result {
                self?.getSunTimes(dates: dates, location: location, completion: completion)
            }
            if case .failure (let error) = result {
                completion(.failure(error))
            }
        }
    }

    private func getSunTimes(
        dates: [Date],
        location: CLLocation,
        completion: @escaping GetSunTimeCompletion
    ) {
        Task {
            let result = await sunTimeRepository.requestSunTimes(
                dates: dates,
                location: location
            )
            if case .success (let res) = result {
                completion(.success(
                    ((res.0.sorted { $0.sunrise < $1.sunrise }), res.1))
                )
            }
            if case .failure (let error) = result {
                completion(.failure(error))
            }
        }
    }

    private func makeDates(since date: Date, numberOfDays: Int) -> [Date] {
        guard numberOfDays > 0 else { return [] }
        return (0...numberOfDays - 1).map {
            date.addingTimeInterval(days: $0)
        }
    }
}
