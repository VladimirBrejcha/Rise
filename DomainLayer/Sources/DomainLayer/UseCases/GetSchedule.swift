import Foundation
import Core
import DataLayer

public protocol HasGetSchedule {
    var getSchedule: GetSchedule { get }
}

public protocol GetSchedule {
    func yesterday() -> Schedule?
    func today() -> Schedule?
    func tomorrow() -> Schedule?
    func forNextDays(
        numberOfDays: Int,
        startToday: Bool
    ) -> [Schedule]
}

final class GetScheduleImpl: GetSchedule {

    private let scheduleRepository: ScheduleRepository
    private let createNextSchedule: CreateNextSchedule
    private let dateGenerator: () -> Date

    init(_ scheduleRepository: ScheduleRepository,
         _ createNextSchedule: CreateNextSchedule,
         dateGenerator: @escaping () -> Date = Date.init
    ) {
        self.dateGenerator = dateGenerator
        self.scheduleRepository = scheduleRepository
        self.createNextSchedule = createNextSchedule
    }

    func yesterday() -> Schedule? {
        getSchedule(for: dateGenerator().addingTimeInterval(days: -1))
    }

    func today() -> Schedule? {
        getSchedule(for: dateGenerator())
    }

    func tomorrow() -> Schedule? {
        getSchedule(for: dateGenerator()
            .addingTimeInterval(days: 1))
    }

    func forNextDays(
        numberOfDays: Int,
        startToday: Bool
    ) -> [Schedule] {
        let startDay = startToday ? 0 : 1
        let endDay = numberOfDays - (startToday ? 1 : 0)
        var result: [Schedule] = []
        for day in (startDay...endDay) {
            let date = dateGenerator()
                .addingTimeInterval(days: day)
            guard let s = getSchedule(for: date) else {
                break
            }
            result.append(s)
        }
        return result
    }

    private func getSchedule(for date: Date) -> Schedule? {
        if let schedule = scheduleRepository.get(for: date.noon) {
            return schedule
        }
        if let latestSchedule = scheduleRepository.getLatest() {
            if latestSchedule.wakeUp.noon > date.noon {
                log(.info, "the date \(date.noon) is before latest schedule \(latestSchedule.wakeUp.noon), schedule doesnt exist")
                return nil
            }
            log(.info, "preparing next schedule for date \(date.noon), latest schedule date is \(latestSchedule.wakeUp.noon)")
            return getAndSaveNext(from: latestSchedule, untilDate: date)
        }
        return nil
    }

    private func getAndSaveNext(from schedule: Schedule, untilDate: Date) -> Schedule {
        let next = createNextSchedule(from: schedule)
        scheduleRepository.save(next)
        if next.wakeUp.noon == untilDate.noon {
            return next
        }
        return getAndSaveNext(from: next, untilDate: untilDate)
    }
}
