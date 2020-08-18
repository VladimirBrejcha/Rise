//
//  NetworkErrors.swift
//  Rise
//
//  Created by Владимир Королев on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case serverError
    case responseError
    case internetError
    case runOfSpace

    // MARK: - LocalizedError -
    var errorDescription: String? {
        switch self {
        case .serverError, .responseError:
            return "Something bad happened"
        case .internetError:
            return "No internet connection"
        case .runOfSpace:
            return "Run out of space"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .serverError, .responseError:
            return nil
        case .internetError:
            return "Please check your internet connection"
        case .runOfSpace:
            return "Please "
        }
    }
}
