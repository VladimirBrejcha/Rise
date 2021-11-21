//  
//  AdjustScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class AdjustScheduleAssembler {
    func assemble(
        currentSchedule: Schedule,
        completion: ((Bool) -> Void)? = nil
    ) -> AdjustScheduleViewController {
        AdjustScheduleViewController(
            adjustSchedule: DomainLayer.adjustSchedule,
            currentSchedule: currentSchedule,
            completion: completion
        )
    }
}
