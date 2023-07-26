import Core
import Foundation
import WeatherKit
import CoreLocation

public struct WKLegal: Equatable { public let img: Data; public let url: URL }

public protocol WeatherService {
    func requestSunTimes(
        for dateInterval: DateInterval,
        location: CLLocation
    ) async throws -> [SunTime]

    func getAttribution() async throws -> WKLegal
}

final class WKServiceImpl: WeatherService {

    private let ws = WeatherKit.WeatherService.shared

    func getAttribution() async throws -> WKLegal {
        let atr = try await ws.attribution
        let img = try Data(contentsOf: atr.combinedMarkDarkURL)
        return WKLegal(img: img, url: atr.legalPageURL)
    }

    func requestSunTimes(
        for dateInterval: DateInterval,
        location: CLLocation
    ) async throws -> [SunTime] {
        log(.info, "requestSunTimes for: \(dateInterval), location: \(location)")
        do {
            let weather = try await ws.weather(
                for: location,
                including: .daily(
                    startDate: dateInterval.start,
                    endDate: dateInterval.end
                )
            )
            return weather.forecast.compactMap {
                guard let rise = $0.sun.sunrise,
                      let set = $0.sun.sunset
                else { return nil }
                return SunTime(sunrise: rise, sunset: set)
            }
        } catch let error {
            log(.error, error.localizedDescription)
            throw error
        }
    }
}

extension Date {
    func adjustToMy() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        // Change to a readable time format and change to Taiwan Standard Time
        dateFormatter.timeZone = TimeZone(abbreviation: "Asia/Taipei")
        return  dateFormatter.string(from: self)
    }
}
