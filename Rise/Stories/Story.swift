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
          fatalError()
//            return RootStoryAssembler().assemble()
        case .tabBar:
            return TabBarController(
                items: [Story.schedule(), Story.today(), Story.settings()],
                selectedIndex: 1
            )
        case .onboarding:
          fatalError()
        case .today:
//            return TodayAssembler().assemble()
          fatalError()
        case .days:
          fatalError()
//            return DaysAssembler().assemble()
        case .schedule:
//            return ScheduleAssembler().assemble()
          fatalError()
        case .settings:
//            return SettingsAssembler().assemble()
          fatalError()
        case let .editSchedule(schedule):
//            return EditScheduleAssembler().assemble(schedule: schedule)
          fatalError()
        case .prepareToSleep:
//            return PrepareToSleepAssembler().assemble()
          fatalError()
        case .sleep(let alarmTime):
//            return SleepAssembler().assemble(alarm: alarmTime)
          fatalError()
        case .alarming:
            return AlarmingAssembler().assemble()
        case .about:
            return AboutAssembler().assemble()
        case .refreshSunTime:
//            return RefreshSunTimesAssembler().assemble()
          fatalError()
        case let .adjustSchedule(currentSchedule, selectedToBed, completion):
            return AdjustScheduleAssembler().assemble(
                currentSchedule: currentSchedule,
                selectedToBed: selectedToBed,
                completion: completion
            )
        case let .keepAppOpenedSuggestion(completion):
//            return KeepAppOpenedSuggestionAssembler().assemble(
//                completion: completion
//            )
          fatalError()
        case .afterSleep:
            return AfterSleepAssembler().assemble()
        }
    }
}
