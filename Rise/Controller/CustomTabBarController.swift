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
        
        setupTabBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupIcons()
    }
    
    // MARK: TabBar UI setup
    private func setupTabBarUI() {
        
        setupButtonBackground()
        
        tabBar.shadowImage = UIImage()
        
    }
    
    private func setupIcons() {
        
        selectedIndex = 1
        
        tabBar.items![1].image = #imageLiteral(resourceName: "sleepIcon").withRenderingMode(.alwaysOriginal)
        tabBar.items![1].selectedImage = #imageLiteral(resourceName: "sleepIconPressed").withRenderingMode(.alwaysOriginal)

        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
    }
    
    private func setupButtonBackground() {
        middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union")
        
        tabBar.addSubview(middleButtonBackgroundImageView)

        middleButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        middleButtonBackgroundImageView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        middleButtonBackgroundImageView.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor).isActive = true
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
