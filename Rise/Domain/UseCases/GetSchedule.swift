//
//  GetSchedule.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetSchedule {
    func yesterday() -> Schedule?
    func today() -> Schedule?
    func tomorrow() -> Schedule?
}

final class GetScheduleImpl: GetSchedule {

    private let scheduleRepository: ScheduleRepository
    private let createNextSchedule: CreateNextSchedule

    init(_ scheduleRepository: ScheduleRepository, _ createNextSchedule: CreateNextSchedule) {
        self.scheduleRepository = scheduleRepository
        self.createNextSchedule = createNextSchedule
    }

    func yesterday() -> Schedule? {
        scheduleRepository.get(for: Date().addingTimeInterval(days: -1).noon)
    }

    func today() -> Schedule? {
        scheduleRepository.get(for: Date().noon)
    }

    func tomorrow() -> Schedule? {
        scheduleRepository.get(for: Date().addingTimeInterval(days: 1).noon)
    }

    private func getSchedule(for date: Date) -> Schedule? {
        if let schedule = scheduleRepository.get(for: date) {
            return schedule
        }
        if let latestSchedule = scheduleRepository.getLatest() {
            if latestSchedule.wakeUp.noon > date.noon {
                return nil
            }
            return getAndSaveNext(from: latestSchedule, untilDate: latestSchedule.wakeUp)
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
