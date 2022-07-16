import Foundation

public struct SunTime: Decodable, Equatable {

  public let sunrise, sunset: Date

  public init(sunrise: Date, sunset: Date) {
    self.sunrise = sunrise
    self.sunset = sunset
  }
}
