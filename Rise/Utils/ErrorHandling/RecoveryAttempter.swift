//
//  RecoveryAttempter.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

struct RecoveryAttempter {
    private let recoveryOptions: [RecoveryOptions]

    var recoveryOptionsText: [String] { recoveryOptions.map(\.title) }

    init(recoveryOptions: [RecoveryOptions]) {
        self.recoveryOptions = recoveryOptions
    }

    func attemptRecovery(fromError error: Error, optionIndex: Int) -> Bool {
        switch recoveryOptions[optionIndex] {
        case .tryAgain(let action):
            action()
            return true
        case .custom(_, let action):
            action()
            return true
        case .cancel:
            return false
        }
    }

    static func tryAgainAttempter(block: @escaping (() -> Void)) -> Self {
        RecoveryAttempter(recoveryOptions: [.cancel, .tryAgain(action: block)])
    }

    static func cancellableAttempter(options: [RecoveryOptions]) -> Self {
        RecoveryAttempter(recoveryOptions: [.cancel] + options)
    }
}
