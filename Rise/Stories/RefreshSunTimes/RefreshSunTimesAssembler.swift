//
//  RefreshSunTimesAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class RefreshSunTimesAssembler {
    func assemble() -> RefreshSunTimesViewController {
        RefreshSunTimesViewController(
            refreshSunTime: DomainLayer.refreshSunTime
        )
    }
}
