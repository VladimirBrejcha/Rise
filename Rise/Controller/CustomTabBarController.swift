//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let sleepViewController = storyboard.instantiateViewController(withIdentifier: "sleep")
        let settingsViewContoller = storyboard.instantiateViewController(withIdentifier: "settings")
        let alarmViewController = storyboard.instantiateViewController(withIdentifier: "alarm")
        
        self.delegate = self
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Union")
        tabBar.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalToSystemSpacingAfter: tabBar.centerXAnchor, multiplier: 1).isActive = true
        imageView.centerYAnchor.constraint(equalToSystemSpacingBelow: tabBar.centerYAnchor, multiplier: 1).isActive = true
        sleepViewController.tabBarItem.image = #imageLiteral(resourceName: "sleepIcon")
        settingsViewContoller.tabBarItem.image = #imageLiteral(resourceName: "settings")
        settingsViewContoller.tabBarItem.selectedImage = #imageLiteral(resourceName: "settingsPressed")
        alarmViewController.tabBarItem.image = #imageLiteral(resourceName: "alarm")
        alarmViewController.tabBarItem.selectedImage = #imageLiteral(resourceName: "alarmPressed")
        
        viewControllers = [alarmViewController, sleepViewController, settingsViewContoller]
        tabBarController?.selectedViewController = sleepViewController
        tabBar.shadowImage = UIImage()
        createTabBarbackground()
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    func createTabBarbackground() {
        let width = tabBar.bounds.width
        let height = tabBar.bounds.height
        var selectionImage = #imageLiteral(resourceName: "TabBarBackground2")
        let tabSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(tabSize)
        selectionImage.draw(in: CGRect(x: 0, y: 0, width: tabSize.width, height: tabSize.height))
        selectionImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        tabBar.backgroundImage = selectionImage
    }
    
//    // MARK: UITabbar Delegate
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController.isKind(of: SleepViewController.self) {
//            print("middle button pressed")
//            return false
//        }
//        return true
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 50
        return sizeThatFits
    }
}
