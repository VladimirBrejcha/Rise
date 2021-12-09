//
//  TodayAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 05.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayAssembler {
    func assemble() -> TodayViewController {
        let vc = TodayViewController(
            getSchedule: DomainLayer.getSchedule,
            adjustSchedule: DomainLayer.adjustSchedule
        )
        vc.tabBarItem = UITabBarItem.withSystemIcons(
            normal: "moon.stars",
            selected: "moon.stars.fill",
            size: 25
        )
        return vc
    }
}
