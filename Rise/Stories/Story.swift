//
//  Story.swift
//  Rise
//
//  Created by Владимир Королев on 04.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

enum Story {
    // main
    case today
    case plan
    case settings
    
    // setup plan
    case setupPlan
    case welcomeSetupPlan
    case sleepDurationSetupPlan(sleepDurationOutput: (Int) -> Void)
    case wakeUpTimeSetupPlan(wakeUpTimeOutput: (Date) -> Void)
    case planDurationSetupPlan(planDurationOutput: (Int) -> Void)
    case wentSleepSetupPlan(wentSleepOutput: (Date) -> Void)
    case planCreatedSetupPlan
}
