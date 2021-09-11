//
//  AppDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let notificationManager = NotificationManager()
    
    static private(set) var alertWindow: UIWindow = {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.backgroundColor = .clear

        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        alertWindow.rootViewController = viewController

        return alertWindow
    }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        notificationManager.configure()
        let viewController = OnboardingViewController(data: [
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
        ])
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        return true
    }
}
