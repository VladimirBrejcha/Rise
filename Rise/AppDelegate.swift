//
//  AppDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    private lazy var mainWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let nc = UINavigationController(
            rootViewController: DataLayer.userData.onboardingCompleted
                ? Story.tabBar()
                : Story.onboarding(dismissOnCompletion: false)()
        )
        nc.navigationBar.isHidden = true
        window.rootViewController = nc
        window.makeKeyAndVisible()
        return window
    }()

    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = mainWindow
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataLayer.userData.latestAppUsageDate = Date()
    }
}
