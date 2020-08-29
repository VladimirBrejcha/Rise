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
    case sleepDurationCreatePlan(sleepDurationOutput: (Int) -> Void, sleepDurationDataSource: @autoclosure () -> Int?)
    case wakeUpTimeCreatePlan(wakeUpTimeOutput: (Date) -> Void, wakeUpTimeDataSource: @autoclosure () -> Date?)
    case planDurationCreatePlan(planDurationOutput: (Int) -> Void, planDurationDataSource: @autoclosure () -> Int?)
    case wentSleepCreatePlan(wentSleepOutput: (Date) -> Void, wentSleepDataSource: @autoclosure () -> Date?)
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
        case .sleepDurationCreatePlan(let sleepDurationOutput, let sleepDurationDataSource):
            let controller = Storyboard.setupPlan.instantiateViewController(of: SleepDurationCreatePlanViewController.self)
            controller.sleepDurationOutput = sleepDurationOutput
            controller.presettedSleepDuration = sleepDurationDataSource()
            return controller
        case .wakeUpTimeCreatePlan(let wakeUpTimeOutput, let wakeUpTimeDataSource):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WakeUpTimeCreatePlanViewController.self)
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            controller.presettedWakeUpTime = wakeUpTimeDataSource()
            return controller
        case .planDurationCreatePlan(let planDurationOutput, let planDurationDataSource):
            let controller = Storyboard.setupPlan.instantiateViewController(of: PlanDurationCreatePlanViewController.self)
            controller.planDurationOutput = planDurationOutput
            controller.presettedPlanDuration = planDurationDataSource()
            return controller
        case .wentSleepCreatePlan(let wentSleepOutput, let wentSleepDataSource):
            let controller = Storyboard.setupPlan.instantiateViewController(of: WentSleepCreatePlanViewController.self)
            controller.wentSleepTimeOutput = wentSleepOutput
            controller.presettedWentSleepTime = wentSleepDataSource()
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
