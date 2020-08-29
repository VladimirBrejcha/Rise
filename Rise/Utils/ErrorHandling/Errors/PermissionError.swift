//
//  PermissionError.swift
//  Rise
//
//  Created by Владимир Королев on 29.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum PermissionError: LocalizedError {
    case locationAccessDenied
    
    // MARK: - LocalizedError -
    var errorDescription: String? { "Access to location was not granted" }
    var recoverySuggestion: String? { "Please allow the app to access location" }
}
