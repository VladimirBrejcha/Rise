//
//  Story.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Story {
    // Onboarding
    case onboarding(dismissOnCompletion: Bool)

    // Main
    case tabBar
    case today
    case days
    case schedule
    case settings
    
    // Create schedule
    case createSchedule
    case welcomeCreateSchedule
    case sleepDurationCreateSchedule(sleepDurationOutput: (Int) -> Void, presettedSleepDuration: Int?)
    case wakeUpTimeCreateSchedule(wakeUpTimeOutput: (Date) -> Void, presettedWakeUpTime: Date?)
    case wentSleepCreateSchedule(wentSleepOutput: (Date) -> Void, presettedWentSleepTime: Date?)
    case scheduleCreatedCreateSchedule
    
    // Edit schedule
    case editSchedule
    
    // Сonfirmation
    case confirmation
    
    // Sleep
    case prepareToSleep
    case sleep(alarmTime: Date)
    case alarming(alarmTime: Date)

    // Settings
    case about
    
    func callAsFunction() -> UIViewController {
        switch self {
        case .tabBar:
            return CustomTabBarController(
                items: [Story.schedule(), Story.today(), Story.settings()],
                selectedIndex: 1
            )
        case let .onboarding(dismissOnCompletion):
            return OnboardingAssembler().assemble(dismissOnCompletion: dismissOnCompletion)
        case .today:
            return TodayAssembler().assemble()
        case .days:
            return DaysAssembler().assemble()
        case .schedule:
            return ScheduleAssembler().assemble()
        case .settings:
            return SettingsAssembler().assemble()
        case .createSchedule:
            return CreateScheduleAssembler().assemble()
        case .welcomeCreateSchedule:
            return Storyboard.createSchedule.instantiateViewController(
                of: WelcomeCreateScheduleViewController.self
            )
        case .sleepDurationCreateSchedule(let sleepDurationOutput, let presettedSleepDuration):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: SleepDurationCreateScheduleViewController.self
            )
            controller.sleepDurationOutput = sleepDurationOutput
            controller.presettedSleepDuration = presettedSleepDuration
            return controller
        case .wakeUpTimeCreateSchedule(let wakeUpTimeOutput, let presettedWakeUpTime):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: WakeUpTimeCreateScheduleViewController.self
            )
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            controller.presettedWakeUpTime = presettedWakeUpTime
            return controller
        case .wentSleepCreateSchedule(let wentSleepOutput, let presettedWentSleepTime):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: WentSleepCreateScheduleViewController.self
            )
            controller.wentSleepTimeOutput = wentSleepOutput
            controller.presettedWentSleepTime = presettedWentSleepTime
            return controller
        case .scheduleCreatedCreateSchedule:
            let controller = Storyboard.createSchedule.instantiateViewController(of: ScheduleCreatedCreateScheduleViewController.self)
            return controller
        case .editSchedule:
            return EditScheduleAssembler().assemble()
        case .confirmation:
            return ConfirmationAssembler().assemble()
        case .prepareToSleep:
            return PrepareToSleepAssembler().assemble()
        case .sleep(let alarmTime):
            return SleepAssembler().assemble(alarm: alarmTime)
        case .alarming(let alarmTime):
            return AlarmingAssembler().assemble(alarm: alarmTime)
        case .about:
            return AboutAssembler().assemble()
        }
    }
}
