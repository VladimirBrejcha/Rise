//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    private var middleButtonBackgroundImageView = UIImageView()
    private var gradientManager: GradientManager?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.tintColor = .clear
        selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        gradientManager = GradientManager(frame: view.bounds)
        gradientManager?.frame = view.bounds
        let gradientView = gradientManager?.createAnimatedGradient(colors: [[#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.168627451, blue: 0.2705882353, alpha: 1)],
                                                                            [#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.1490196078, green: 0.1568627451, blue: 0.3137254902, alpha: 1)],
                                                                            [#colorLiteral(red: 0.1490196078, green: 0.1568627451, blue: 0.3137254902, alpha: 1), #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)],
                                                                            [#colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0.4588235294, green: 0.168627451, blue: 0.2705882353, alpha: 1)]], directions: [.up, .upLeft, .upRight, .up])
        view.addSubview(gradientView!)
        view.sendSubviewToBack(gradientView!)
    }
    
    // MARK: TabBar UI setup
    override func viewSafeAreaInsetsDidChange() {
        middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union2")
        
        tabBar.addSubview(middleButtonBackgroundImageView)
        
        middleButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        middleButtonBackgroundImageView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                             constant: 6).isActive = true
        middleButtonBackgroundImageView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor,
                                                                constant: -(6 + view.safeAreaInsets.bottom)).isActive = true
        middleButtonBackgroundImageView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
        
        setupTabBarItems()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item == tabBar.items?[1] {
            middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union2")
        } else {
            middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union")
        }
        
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
