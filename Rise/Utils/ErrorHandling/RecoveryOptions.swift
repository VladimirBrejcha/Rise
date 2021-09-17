//
//  RecoveryOptions.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

enum RecoveryOptions {
    case tryAgain(action: (() -> Void))
    case custom(title: String, action: (() -> Void))
    case cancel

    var title: String {
        switch self {
        case .tryAgain:
            return "Try again"
        case .custom(let title, _):
            return title
        case .cancel:
            return "Cancel"
        }
    }
}
