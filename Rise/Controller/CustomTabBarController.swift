//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: Properties
    private var middleButtonBackgroundImageView = UIImageView()
    let animatedGradient = AnimatedGradientView()
    private var gradientManager: GradientManager?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.tintColor = .clear
        selectedIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gradientManager = GradientManager()
        let gradientView = gradientManager?.createAnimatedGradient(colorsArray: [[#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)], [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)], [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)], [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]],
                                                directionsArray: [.up, .upLeft, .upRight, .up],
                                                frame: view.bounds)
        
        
        animatedGradient.frame = view.bounds
        animatedGradient.animationValues = [(colors: ["#161328", "#752B45"], .up, .axial),
                                            (colors: ["#161328", "#262850"], .upLeft, .axial),
                                            (colors: ["#262850", "#161328"], .upRight, .axial),
                                            (colors: ["#161328", "#752B45"], .up, .axial)]
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
