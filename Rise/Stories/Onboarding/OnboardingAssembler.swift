//
//  OnboardingAssembler.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

final class OnboardingAssembler {
    func assemble(dismissOnCompletion: Bool = false) -> OnboardingViewController {
        let controller = OnboardingViewController(
            data: [
                .init(
                    title: Text.Onboarding.Title.sleepIsImportant,
                    descriptions: [
                        Text.Onboarding.dreamedOfWakingUpInTime
                    ]
                ),
                .init(
                    title: Text.Onboarding.Title.haveYouScheduledIt,
                    descriptions: [
                        Text.Onboarding.missedAlarm,
                        Text.Onboarding.itHappensWithAllOfUs
                    ]
                ),
                .init(
                    title: Text.Onboarding.Title.meetRise,
                    descriptions: [
                        Text.Onboarding.personalAssistent,
                        Text.Onboarding.secureGoodSleep
                    ]
                ),
            ],
            setOnboardingCompleted: DomainLayer.setOnboardingCompleted,
            dismissOnCompletion: dismissOnCompletion
        )
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        return controller
    }
}
