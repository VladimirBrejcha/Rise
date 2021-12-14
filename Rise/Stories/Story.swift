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
    case onboarding

    // Main
    case root
    case tabBar
    case today
    case days
    case schedule
    case adjustSchedule(
        currentSchedule: Schedule,
        selectedToBed: Date? = nil,
        completion: ((Bool) -> Void)? = nil
    )
    
    // Create schedule
    case createSchedule(onCreate: () -> Void)
    case welcomeCreateSchedule
    case sleepDurationCreateSchedule(
        sleepDurationOutput: (Int) -> Void,
        currentSleepDuration: () -> Schedule.Minute?
    )
    case wakeUpTimeCreateSchedule(
        toBedTimeOutput: (Date) -> Void,
        wakeUpTimeOutput: (Date) -> Void,
        currentSleepDuration: () -> Schedule.Minute?,
        currentWakeUpTime: () -> Date?
    )
    case intensityCreateSchedule(
        scheduleIntensityOutput: (Schedule.Intensity) -> Void,
        currentIntensity: () -> Schedule.Intensity?
    )
    case wentSleepCreateSchedule(
        wentSleepOutput: (Date) -> Void,
        currentWentSleepTime: () -> Date?
    )
    case scheduleCreatedCreateSchedule
    
    // Sleep
    case prepareToSleep
    case keepAppOpenedSuggestion(completion: (() -> Void)?)
    case sleep(alarmTime: Date)
    case alarming
    case afterSleep

    // Settings
    case settings
    case about
    case refreshSunTime
    case editSchedule(schedule: Schedule)
    
    func callAsFunction() -> UIViewController {
        switch self {
        case .root:
            return RootStoryAssembler().assemble()
        case .tabBar:
            return TabBarController(
                items: [Story.schedule(), Story.today(), Story.settings()],
                selectedIndex: 1
            )
        case .onboarding:
            return OnboardingAssembler().assemble()
        case .today:
            return TodayAssembler().assemble()
        case .days:
            return DaysAssembler().assemble()
        case .schedule:
            return ScheduleAssembler().assemble()
        case .settings:
            return SettingsAssembler().assemble()
        case let .createSchedule(onCreate):
            return CreateScheduleAssembler().assemble(onCreate: onCreate)
        case .welcomeCreateSchedule:
            return Storyboard.createSchedule.instantiateViewController(
                of: WelcomeCreateScheduleViewController.self
            )
        case let .sleepDurationCreateSchedule(sleepDurationOutput, currentSleepDuration):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: SleepDurationCreateScheduleViewController.self
            )
            controller.sleepDurationOutput = sleepDurationOutput
            controller.currentSleepDuration = currentSleepDuration
            return controller
        case let .wakeUpTimeCreateSchedule(
            toBedTimeOutput, wakeUpTimeOutput, currentSleepDuration, currentWakeUpTime
        ):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: WakeUpTimeCreateScheduleViewController.self
            )
            controller.toBedTimeOutput = toBedTimeOutput
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            controller.currentSleepDuration = currentSleepDuration
            controller.currentWakeUpTime = currentWakeUpTime
            return controller
        case let .intensityCreateSchedule(scheduleIntensityOutput, currentIntensity):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: IntensityCreateScheduleViewController.self
            )
            controller.scheduleIntensityOutput = scheduleIntensityOutput
            controller.currentIntensity = currentIntensity
            return controller
        case let .wentSleepCreateSchedule(wentSleepOutput, currentWentSleepTime):
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: WentSleepCreateScheduleViewController.self
            )
            controller.wentSleepTimeOutput = wentSleepOutput
            controller.currentWentSleepTime = currentWentSleepTime
            return controller
        case .scheduleCreatedCreateSchedule:
            let controller = Storyboard.createSchedule.instantiateViewController(
                of: ScheduleCreatedCreateScheduleViewController.self
            )
            return controller
        case let .editSchedule(schedule):
            return EditScheduleAssembler().assemble(schedule: schedule)
        case .prepareToSleep:
            return PrepareToSleepAssembler().assemble()
        case .sleep(let alarmTime):
            return SleepAssembler().assemble(alarm: alarmTime)
        case .alarming:
            return AlarmingAssembler().assemble()
        case .about:
            return AboutAssembler().assemble()
        case .refreshSunTime:
            return RefreshSunTimesAssembler().assemble()
        case let .adjustSchedule(currentSchedule, selectedToBed, completion):
            return AdjustScheduleAssembler().assemble(
                currentSchedule: currentSchedule,
                selectedToBed: selectedToBed,
                completion: completion
            )
        case let .keepAppOpenedSuggestion(completion):
            return KeepAppOpenedSuggestionAssembler().assemble(
                completion: completion
            )
        case .afterSleep:
            return AfterSleepAssembler().assemble()
        }
    }
}
