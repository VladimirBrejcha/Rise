//
//  UserDefaultsManager.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let userDefaults = UserDefaults.standard
fileprivate let welcomeScreenBeenShowedKey = "welcomeScreenBeenShowed"

extension UserDefaults {
    static var welcomeScreenBeenShowed: Bool {
        get { return userDefaults.bool(forKey: welcomeScreenBeenShowedKey) }
        set { userDefaults.set(newValue, forKey: welcomeScreenBeenShowedKey) }
    }
}
