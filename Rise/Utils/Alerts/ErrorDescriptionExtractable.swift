//
//  ErrorDescriptionExtractable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol ErrorReasonExtractable {
    func errorReason(from error: Error) -> String?
}

extension ErrorReasonExtractable {
    func errorReason(from error: Error) -> String? {
        if let localizedError = error as? LocalizedError {
            return localizedError.recoverySuggestion
        }
        return "Something bad happened. Please try again"
    }
}
