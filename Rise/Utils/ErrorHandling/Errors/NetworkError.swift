//
//  NetworkError.swift
//  Rise
//
//  Created by Владимир Королев on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case serverError
    case responseError
    case responseParsingError
    case noDataReceived
    case internetError

    // MARK: - LocalizedError -
    var errorDescription: String? {
        switch self {
        case .serverError, .responseError, .noDataReceived, .responseParsingError:
            return "Something bad happened"
        case .internetError:
            return "No internet connection"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .serverError, .responseError, .noDataReceived, .responseParsingError:
            return nil
        case .internetError:
            return "Please check your internet connection"
        }
    }
}
