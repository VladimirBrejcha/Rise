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
    
    // MARK: - LocalizedError -
    var errorDescription: String? { "Rise plan is not scheduled for the day" }
    var recoverySuggestion: String? { nil }
}
