//
//  PlanError.swift
//  Rise
//
//  Created by Владимир Королев on 29.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum PlanError: LocalizedError {
    case noPlanForTheDay
    case someFieldsAreMissing
    
    // MARK: - LocalizedError -
    var errorDescription: String? {
        switch self {
        case .noPlanForTheDay:
            return "Rise plan is not scheduled for the day"
        case .someFieldsAreMissing:
            return "Could'not generate the plan because some fields were missing, please try again"
        }
    }
    var recoverySuggestion: String? {
        switch self {
        case .noPlanForTheDay:
            return nil
        case .someFieldsAreMissing:
            return "Try to fill all the fields"
        }
    }
}
