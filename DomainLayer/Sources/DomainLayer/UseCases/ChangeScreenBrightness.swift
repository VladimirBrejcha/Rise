import UIKit

public protocol HasChangeScreenBrightnessUseCase {
  var changeScreenBrightness: ChangeScreenBrightness { get }
}

public enum ScreenBrightnessLevel {
  case low, high, userDefault
}

public protocol ChangeScreenBrightness {
  func callAsFunction(to level: ScreenBrightnessLevel)
}

final class ChangeScreenBrightnessImpl: ChangeScreenBrightness {
  private let screen = UIScreen.main
  private var userDefaultLevel: CGFloat?

  func callAsFunction(to level: ScreenBrightnessLevel) {
    switch level {
    case .low:
      if userDefaultLevel == nil {
        userDefaultLevel = screen.brightness
      }
      screen.brightness = 0.1
    case .high:
      if userDefaultLevel == nil {
        userDefaultLevel = screen.brightness
      }
      screen.brightness = 1.0
    case .userDefault:
      if let userDefaultLevel = userDefaultLevel {
        self.userDefaultLevel = nil
        screen.brightness = userDefaultLevel
      }
    }
  }
}
