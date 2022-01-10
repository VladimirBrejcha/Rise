//
//  OnboardingAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class OnboardingAssembler {
    func assemble() -> OnboardingViewController {
        let controller = OnboardingViewController(
            data: [
                .init(
                    title: Text.Onboarding.Title.sleepIsImportant,
                    descriptions: [
                        Text.Onboarding.aboutSleep,
                        Text.Onboarding.aboutSleep2,
                        Text.Onboarding.aboutSleep3
                    ]
                ),
                .init(
                    title: Text.Onboarding.Title.haveYouScheduledIt,
                    descriptions: [
                        Text.Onboarding.missedAlarm,
                        Text.Onboarding.unableToAdjust,
                        Text.Onboarding.itHappensWithAllOfUs
                    ]
                ),
                .init(
                    title: Text.Onboarding.Title.meetRise,
                    descriptions: [
                        Text.Onboarding.personalAssistant,
                        Text.Onboarding.personalAssistant2,
                        Text.Onboarding.personalAssistant3
                    ]
                ),
            ],
            setOnboardingCompleted: DomainLayer.setOnboardingCompleted
        )
        return controller
    }
}
