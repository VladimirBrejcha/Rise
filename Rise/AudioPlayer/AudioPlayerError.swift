//
//  AudioPlayerError.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

enum AudioPlayerError: LocalizedError {
    case urlBuildingError

    // MARK: - LocalizedError -

    var errorDescription: String? {
        switch self {
        case .urlBuildingError:
            return makeErrorDescriptionWithCode(1)
        }
    }

    var recoverySuggestion: String? { nil }

    private func makeErrorDescriptionWithCode(_ code: Int) -> String {
        "Something bad happened. Please contact the developer (code: \(code))"
    }
}
