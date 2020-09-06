//
//  UserDefaults.swift
//  Rise
//
//  Created by Владимир Королев on 06.09.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let userDefaults = UserDefaults.standard
fileprivate let userDefaultsDomain = Bundle.main.bundleIdentifier ?? ""
fileprivate extension String {
    var appendingAppDomain: String {
        "\(userDefaultsDomain).\(self)"
    }
}

@propertyWrapper
struct UserDefault<T> {
    let key: String

    init(_ key: String) {
        self.key = key.appendingAppDomain
    }

    var wrappedValue: T? {
        get { userDefaults.object(forKey: key) as? T }
        set { userDefaults.set(newValue, forKey: key) }
    }
}

@propertyWrapper
struct NonNilUserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key.appendingAppDomain
        self.defaultValue = defaultValue
        userDefaults.register(defaults: [key: defaultValue])
    }
    
    var wrappedValue: T {
        get { userDefaults.object(forKey: key) as? T ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }
}
