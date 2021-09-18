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
            getPlan: DomainLayer.getPlan,
            observePlan: DomainLayer.observePlan,
            getDailyTime: DomainLayer.getDailyTime,
            confirmPlan: DomainLayer.confirmPlan
        )
        vc.tabBarItem = UITabBarItem(
            title: nil,
            image: Asset.sleepIcon.image,
            selectedImage: Asset.sleepIconPressed.image
        )
        return vc
    }
}
