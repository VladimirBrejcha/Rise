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

    // MARK: - AboveAllAlertController

    static private(set) var alertWindow: UIWindow = {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.backgroundColor = .clear

        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        alertWindow.rootViewController = viewController

        return alertWindow
    }()

    // MARK: - UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        self.window = mainWindow
        return true
    }
}
