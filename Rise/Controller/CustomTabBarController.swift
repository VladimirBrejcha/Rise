//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var sleepViewController: UIViewController!
    var settingsViewContoller: UIViewController!
    var alarmViewController: UIViewController!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sleepViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Controllers.Identifiers.sleep)
        settingsViewContoller = storyboard?.instantiateViewController(withIdentifier: Constants.Controllers.Identifiers.settings)
        alarmViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Controllers.Identifiers.alarm)
        viewControllers = [alarmViewController, sleepViewController, settingsViewContoller]
        selectedIndex = 1
        
        let middleButtonBackgroundImageView = UIImageView()
        middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union")
        
        tabBar.addSubview(middleButtonBackgroundImageView)
        middleButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        middleButtonBackgroundImageView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        middleButtonBackgroundImageView.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
        
        tabBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sleepViewController.tabBarItem.image = #imageLiteral(resourceName: "sleepIcon").withRenderingMode(.alwaysOriginal)
        sleepViewController.tabBarItem.selectedImage = #imageLiteral(resourceName: "sleepIconPressed").withRenderingMode(.alwaysOriginal)
        settingsViewContoller.tabBarItem.image = #imageLiteral(resourceName: "settings")
        settingsViewContoller.tabBarItem.selectedImage = #imageLiteral(resourceName: "settingsPressed")
        alarmViewController.tabBarItem.image = #imageLiteral(resourceName: "alarm")
        alarmViewController.tabBarItem.selectedImage = #imageLiteral(resourceName: "alarmPressed")
        
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        setupTabBarBackground()
        
    }
    
    // MARK: TabBar UI setup
    private func setupTabBarBackground() {
        
        tabBar.shadowImage = UIImage()
        
        let tabBarWidth = tabBar.bounds.width
        let tabBarHeight = tabBar.bounds.height
        let tabBarSize = CGSize(width: tabBarWidth, height: tabBarHeight)
        
        var imageForBackground = #imageLiteral(resourceName: "TabBarBackground2")
        
        UIGraphicsBeginImageContext(tabBarSize)
        imageForBackground.draw(in: CGRect(x: 0, y: 0, width: tabBarSize.width, height: tabBarSize.height))
        imageForBackground = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        tabBar.backgroundImage = imageForBackground
    }
    
}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}
