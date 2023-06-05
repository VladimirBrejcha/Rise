//
//  AppDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import DataLayer
import DomainLayer

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  private let useCaseLocator = UseCaseLocator(
    scheduleRepository: DataLayer.scheduleRepository,
    sunTimeRepository: DataLayer.sunTimeRepository,
    locationRepository: DataLayer.locationRepository,
    userData: DataLayer.userData
  )

  private lazy var coordinator: RootCoordinator = RootCoordinator(
    useCases: useCaseLocator,
    navigationController: rootViewController
  )

  private let rootViewController = NavigationController()

  private lazy var mainWindow: UIWindow = {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    return window
  }()

  // MARK: - UIApplicationDelegate

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = mainWindow
    coordinator.run()
    coordinator.beginTimeToSleepTimer()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    DataLayer.userData.latestAppUsageDate = Date()
      coordinator.stopTimeToSleepTimer()
  }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        coordinator.stopTimeToSleepTimer()
    }
}
