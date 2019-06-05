//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    private var middleButtonBackgroundImageView = UIImageView()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 1
    }
    
    // MARK: TabBar UI setup
    override func viewSafeAreaInsetsDidChange() {
        middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union")
        
        tabBar.addSubview(middleButtonBackgroundImageView)
        
        middleButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        middleButtonBackgroundImageView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                             constant: 3).isActive = true
        middleButtonBackgroundImageView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor,
                                                                constant: -(3 + view.safeAreaInsets.bottom)).isActive = true
        middleButtonBackgroundImageView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        
        tabBar.shadowImage = UIImage()
        
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        
        tabBar.items![1].image = #imageLiteral(resourceName: "sleepIcon").withRenderingMode(.alwaysOriginal)
        tabBar.items![1].selectedImage = #imageLiteral(resourceName: "sleepIconPressed").withRenderingMode(.alwaysOriginal)

        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            tabBarItem.title = nil
        }
    }
}

class CustomTabBar: UITabBar {
    @IBInspectable var height: CGFloat = 0.0
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0)
        }
        return sizeThatFits
    }
}
