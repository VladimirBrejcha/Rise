//
//  InternalError.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum InternalError: LocalizedError {
    case dateBuildingError
    case urlBuildingError
    
    // MARK: - LocalizedError -
    var errorDescription: String? {
        switch self {
        case .dateBuildingError: return makeErrorDescriptionWithCode(0)
        case .urlBuildingError: return makeErrorDescriptionWithCode(1)
        }
    }
    
    var recoverySuggestion: String? { nil }
    
    private func makeErrorDescriptionWithCode(_ code: Int) -> String {
        "Something bad happened. Please contact the developer (code: \(code)"
    }
}

