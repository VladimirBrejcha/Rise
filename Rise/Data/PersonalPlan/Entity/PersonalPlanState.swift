//
//  PersonalPlanState.swift
//  Rise
//
//  Created by Владимир Королев on 04.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

@objc public enum PersonalPlanState: Int32 {
    case paused = 0
    case confirmed = 1
    case needsConfirmation = 2
}
