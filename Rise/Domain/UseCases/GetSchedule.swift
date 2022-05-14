//
//  GetSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol HasGetScheduleUseCase {
  var getSchedule: GetSchedule { get }
}

protocol GetSchedule {
    func yesterday() -> Schedule?
    func today() -> Schedule?
    func tomorrow() -> Schedule?
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
        getSchedule(for: dateGenerator().addingTimeInterval(days: 1))
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
