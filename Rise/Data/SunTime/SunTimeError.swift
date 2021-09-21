//
//  SunTimeError.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

enum SunTimeError: LocalizedError {
    case networkError (underlyingError: NetworkError)
    case internalError

    var errorDescription: String? {
        switch self {
        case .networkError(let underlyingError):
            return "Network error: \(underlyingError.localizedDescription)"
        case .internalError:
            return "Internal error"
        }
    }
}
