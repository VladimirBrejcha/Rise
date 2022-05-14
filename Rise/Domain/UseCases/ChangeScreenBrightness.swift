//
//  ChangeScreenBrightness.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol HasChangeScreenBrightnessUseCase {
    var changeScreenBrightness: ChangeScreenBrightness { get }
}

enum ScreenBrightnessLevel {
    case low
    case high
    case userDefault
}

protocol ChangeScreenBrightness {
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
