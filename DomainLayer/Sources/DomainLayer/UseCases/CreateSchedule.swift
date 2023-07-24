import Foundation
import Core

public protocol HasCreateSchedule {
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
        let (curToBed, wantToBed) = adjustToBeds(
            current: currentToBed, wanted: wantedToBed
        )
        return Schedule(
            sleepDuration: wantedSleepDuration,
            intensity: intensity,
            toBed: curToBed,
            wakeUp: calculateWakeUp(
                toBed: curToBed,
                sleepDuration: wantedSleepDuration
            ),
            targetToBed: wantToBed,
            targetWakeUp: calculateWakeUp(
                toBed: wantToBed,
                sleepDuration: wantedSleepDuration
            )
        )
    }

    private func adjustToBeds(current: Date, wanted: Date) -> (current: Date, wanted: Date) {
        var resWanted = wanted
        while ((current.timeIntervalSince1970 - resWanted.timeIntervalSince1970) / 60 / 60) > 12 {
            resWanted = resWanted.addingTimeInterval(days: 1)
        }
        return (current, resWanted)
    }

    private func calculateWakeUp(toBed: Date, sleepDuration: Int) -> Date {
        toBed
            .addingTimeInterval(days: -1)
            .addingTimeInterval(minutes: sleepDuration)
    }
}
