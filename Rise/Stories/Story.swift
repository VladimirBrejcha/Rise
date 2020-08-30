//
//  Story.swift
//  Rise
//
//  Created by Владимир Королев on 04.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Story {
    // Main
    case today
    case plan
    case settings
    
    // Create plan
    case createPlan
    case welcomeCreatePlan
    case sleepDurationCreatePlan(sleepDurationOutput: (Int) -> Void, presettedSleepDuration: Int?)
    case wakeUpTimeCreatePlan(wakeUpTimeOutput: (Date) -> Void, presettedWakeUpTime: Date?)
    case planDurationCreatePlan(planDurationOutput: (Int) -> Void, presettedPlanDuration: Int?)
    case wentSleepCreatePlan(wentSleepOutput: (Date) -> Void, presettedWentSleepTime: Date?)
    case planCreatedSetupPlan
    
    // Change plan
    case changePlan
    
    // Сonfirmation
    case confirmation
    
    // Sleep
    case prepareToSleep
    case sleep(alarmTime: Date)
    
    func callAsFunction() -> UIViewController {
        switch self {
        case .today:
            return TodayAssembler().assemble()
        case .plan:
            return PersonalPlanAssembler().assemble()
        case .settings:
            return SettingsAssembler().assemble()
        case .createPlan:
            return CreatePlanAssembler().assemble()
        case .welcomeCreatePlan:
            let controller = Storyboard.setupPlan.instantiateViewController(of: WelcomeCreatelPlanViewController.self)
            return controller
        case .sleepDurationCreatePlan(let sleepDurationOutput, let presettedSleepDuration):
            let controller = Storyboard.setupPlan.instantiateViewController(of: SleepDurationCreatePlanViewController.self)
            controller.sleepDurationOutput = sleepDurationOutput
            controller.presettedSleepDuration = presettedSleepDuration
            return controller
        case .wakeUpTimeCreatePlan(let wakeUpTimeOutput, let presettedWakeUpTime):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WakeUpTimeCreatePlanViewController.self)
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            controller.presettedWakeUpTime = presettedWakeUpTime
            return controller
        case .planDurationCreatePlan(let planDurationOutput, let presettedPlanDuration):
            let controller = Storyboard.setupPlan.instantiateViewController(of: PlanDurationCreatePlanViewController.self)
            controller.planDurationOutput = planDurationOutput
            controller.presettedPlanDuration = presettedPlanDuration
            return controller
        case .wentSleepCreatePlan(let wentSleepOutput, let presettedWentSleepTime):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WentSleepCreatePlanViewController.self)
            controller.wentSleepTimeOutput = wentSleepOutput
            controller.presettedWentSleepTime = presettedWentSleepTime
            return controller
        case .planCreatedSetupPlan:
            let controller = Storyboard.setupPlan.instantiateViewController(of: PlanCreatedCreatePlanViewController.self)
            return controller
        case .changePlan:
            return ChangePlanAssembler().assemble()
        case .confirmation:
            return ConfirmationAssembler().assemble()
        case .prepareToSleep:
            return PrepareToSleepAssembler().assemble()
        case .sleep(let alarmTime):
            return SleepAssembler().assemble(alarm: alarmTime)
        }
    }
}
