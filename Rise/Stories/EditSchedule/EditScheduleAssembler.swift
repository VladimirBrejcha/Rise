//
//  EditScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 02.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

final class EditScheduleAssembler {    
    func assemble(schedule: Schedule) -> EditScheduleViewController {
        EditScheduleViewController(
            updateSchedule: DomainLayer.updateSchedule,
            deleteSchedule: DomainLayer.deleteSchedule,
            schedule: schedule
        )
    }
}
