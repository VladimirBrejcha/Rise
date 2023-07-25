import Foundation
import Core
import CoreLocation

public typealias SunTimesResult
= Result<([SunTime], WKLegal), SunTimeError>

public struct Cache<T> {
    let dateStored: Date
    let items: T?

    init(dateStored: Date = .now, items: T?) {
        self.dateStored = dateStored
        self.items = items
    }

    public func retrieve() -> T? {
        guard let items else { return nil }
        if ((Date().timeIntervalSince1970 - dateStored.timeIntervalSince1970) / 60 / 60) < 24 {
            return items
        }
        return nil
    }
}

public protocol SunTimeRepository {

    var cached: Cache<([SunTime], WKLegal)>? { get }

    func requestSunTimes(dates: [Date], location: CLLocation) async -> SunTimesResult

    func deleteAll()
}
