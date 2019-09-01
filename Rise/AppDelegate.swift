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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: LifeCycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        realmSetup()
        return true
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

