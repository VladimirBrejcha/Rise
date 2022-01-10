//
//  RootStoryAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 06.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class RootStoryAssembler {
    func assemble() -> UIViewController {
        var controllers: [UIViewController] = [Story.tabBar()]

        if let activeSleepEndDate = DomainLayer.manageActiveSleep.alarmAt {
            switch (Date().timeIntervalSince(activeSleepEndDate) / 60) {
            case ..<0:
                controllers.append(
                    Story.sleep(alarmTime: activeSleepEndDate)()
                )
            case 0...30:
                controllers.append(Story.alarming())
            default:
                // if expected wake up happened more than 30 minutes ago, discard sleep
                DomainLayer.manageActiveSleep.endSleep()
            }
        }
        
//        else if !DataLayer.userData.onboardingCompleted {
        else if true {
            controllers.append(Story.onboarding())
        }

        return NavigationController(items: controllers)
    }
}
