import Foundation
import Core

public protocol HasCreateScheduleUseCase {
  var createSchedule: CreateSchedule { get }
}

public protocol CreateSchedule {
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
