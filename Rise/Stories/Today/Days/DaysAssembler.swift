//
//  DaysViewAssembler.swift
//  Rise
//
//  Created by Владимир Королев on 08.03.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysAssembler {
    func assemble(frame: CGRect) -> DaysViewController {
        DaysViewController(
            getSunTime: DomainLayer.getSunTime,
            getPlan: DomainLayer.getPlan,
            observePlan: DomainLayer.observePlan,
            getDailyTime: DomainLayer.getDailyTime,
            frame: frame
        )
    }
}
