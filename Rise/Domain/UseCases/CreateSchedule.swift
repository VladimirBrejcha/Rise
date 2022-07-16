//
//  CreateSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation
import Core

protocol HasCreateScheduleUseCase {
  var createSchedule: CreateSchedule { get }
}

protocol CreateSchedule {
  func callAsFunction(
    wantedSleepDuration: Int,
    currentToBed: Date,
    wantedToBed: Date,
    intensity: Schedule.Intensity
  ) -> Schedule
}

final class CreateScheduleImpl: CreateSchedule {
  func callAsFunction(
    wantedSleepDuration: Int,
    currentToBed: Date,
    wantedToBed: Date,
    intensity: Schedule.Intensity
  ) -> Schedule {
    .init(
      sleepDuration: wantedSleepDuration,
      intensity: intensity,
      toBed: currentToBed,
      wakeUp: calculateWakeUp(
        toBed: currentToBed,
        sleepDuration: wantedSleepDuration
      ),
      targetToBed: wantedToBed,
      targetWakeUp: calculateWakeUp(
        toBed: wantedToBed,
        sleepDuration: wantedSleepDuration
      )
    )
  }
  
  private func calculateWakeUp(toBed: Date, sleepDuration: Int) -> Date {
    toBed
      .addingTimeInterval(days: -1)
      .addingTimeInterval(minutes: sleepDuration)
  }
}
