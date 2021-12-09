//
//  ScheduleAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScheduleAssembler {
    func assemble() -> ScheduleViewController {
        let vc = ScheduleViewController(
            getSchedule: DomainLayer.getSchedule,
            pauseSchedule: DomainLayer.pauseSchedule
        )
        vc.tabBarItem = UITabBarItem.withSystemIcons(
            normal: "person",
            selected: "person.fill"
        )
        return vc
    }
}
