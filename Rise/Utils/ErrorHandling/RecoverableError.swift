//
//  RecoverableError.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

struct RecoverableError: Foundation.RecoverableError, LocalizedError {
    let error: Error
    let attempter: RecoveryAttempter
    
    var localizedError: LocalizedError? { error as? LocalizedError }
    
    // MARK: - Foundation.RecoverableError -
    var recoveryOptions: [String] { attempter.recoveryOptionsText }
    
    @discardableResult
    func attemptRecovery(optionIndex recoveryOptionIndex: Int) -> Bool {
        attempter.attemptRecovery(fromError: error, optionIndex: recoveryOptionIndex)
    }

    func attemptRecovery(optionIndex: Int, resultHandler: (Bool) -> Void) {
        resultHandler(attempter.attemptRecovery(fromError: error, optionIndex: optionIndex))
    }
    
    // MARK: - LocalizedError -
    var errorDescription: String? { localizedError?.errorDescription ?? "Something bad happened" }
    var recoverySuggestion: String? { localizedError?.recoverySuggestion }
}
