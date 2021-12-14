//  
//  AdjustScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class AdjustScheduleAssembler {
    func assemble(
        currentSchedule: Schedule,
        selectedToBed: Date? = nil,
        completion: ((Bool) -> Void)? = nil
    ) -> AdjustScheduleViewController {
        AdjustScheduleViewController(
            adjustSchedule: DomainLayer.adjustSchedule,
            currentSchedule: currentSchedule,
            selectedToBed: selectedToBed,
            completion: completion
        )
    }
}
