//
//  AppDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import RealmSwift

let sharedLocationManager = LocationManager()

fileprivate let mainAppScreenIdentifier = "mainAppScreen"
fileprivate let welcomeScreenIdentifier = "welcomeScreen"

extension UIStoryboard {
    class var welcomeScreenController: UIViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: welcomeScreenIdentifier)
    }
    class var mainAppController: UIViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: mainAppScreenIdentifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: LifeCycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupInitialController()
        realmSetup()
        
        return true
    }
    
    private func setupInitialController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UserDefaults.welcomeScreenBeenShowed
            ? UIStoryboard.mainAppController
            : UIStoryboard.welcomeScreenController
        window?.makeKeyAndVisible()
    }
    
    private func realmSetup() {
        do {
            _ = try Realm() //initialising Realm
        } catch {
            print("error creating realm \(error)")
        }
        //to check realm file path
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
}

