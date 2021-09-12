//
//  AboutAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class AboutAssembler {
    func assemble() -> AboutViewController {
        AboutViewController(getAppVersion: DomainLayer.getAppVersion)
    }
}
