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
        
        let controller = storyboard.instantiateViewController(withIdentifier: "123")
        
        self.delegate = self
        
        controller.tabBarItem.image = #imageLiteral(resourceName: "AlarmIcon")
        
        viewControllers = [controller]
        
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: SleepViewController.self) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let controller = storyboard.instantiateViewController(withIdentifier: "123")
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    
    

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
        sizeThatFits.height = 44
        return sizeThatFits
    }
}
