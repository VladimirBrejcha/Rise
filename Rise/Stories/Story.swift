//
//  Story.swift
//  Rise
//
//  Created by Владимир Королев on 04.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

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
    
    // confirmation
    case confirmation
    
    func configure() -> UIViewController {
        switch self {
        case .today:
            return TodayAssembler().assemble()
        case .plan:
            return PersonalPlanAssembler().assemble()
        case .settings:
            return SettingsAssembler().assemble()
        case .setupPlan:
            return SetupPlanAssembler().assemble()
        case .welcomeSetupPlan:
            let controller = Storyboard.setupPlan.instantiateViewController(of: WelcomeSetuplPlanViewController.self)
            return controller
        case .sleepDurationSetupPlan(let sleepDurationOutput):
            let controller = Storyboard.setupPlan.instantiateViewController(of: SleepDurationSetupPlanViewController.self)
            controller.sleepDurationOutput = sleepDurationOutput
            return controller
        case .wakeUpTimeSetupPlan(let wakeUpTimeOutput):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WakeUpTimeSetupPlanViewController.self)
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            return controller
        case .planDurationSetupPlan(let planDurationOutput):
            let controller = Storyboard.setupPlan.instantiateViewController(of: PlanDurationSetupPlanViewController.self)
            controller.planDurationOutput = planDurationOutput
            return controller
        case .wentSleepSetupPlan(let wentSleepOutput):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WentSleepSetupPlanViewController.self)
            controller.wentSleepTimeOutput = wentSleepOutput
            return controller
        case .planCreatedSetupPlan:
            let controller = Storyboard.setupPlan.instantiateViewController(of: PlanCreatedSetupPlanViewController.self)
            return controller
        case .confirmation:
            return ConfirmationAssembler().assemble()
        }
    }
}
