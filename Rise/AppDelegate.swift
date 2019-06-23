//
//  AppDelegate.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties
    var window: UIWindow?
    
    // MARK: LifeCycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            _ = try Realm() //initialising Realm
        } catch {
            print("error creating realm \(error)")
        }
        //to check realm file path
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        UITabBar.appearance().backgroundImage = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 0.1007922535).image()
        UITabBar.appearance().shadowImage = UIImage()
        
        return true
    }
    
}

// MARK: Extensions
extension UIColor { //allows to create UIImage from UIColor
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
