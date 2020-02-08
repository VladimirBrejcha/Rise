//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let middleButtonBackgroundImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let backgroundView = GradientHelper.makeDefaultAnimatedGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        viewControllers = [Story.plan.configure(),
                           Story.today.configure(),
                           Story.settings.configure()]
        
        selectedIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.items![1].image = #imageLiteral(resourceName: "sleepIcon").withRenderingMode(.alwaysOriginal)
        tabBar.items![1].selectedImage = #imageLiteral(resourceName: "sleepIconPressed").withRenderingMode(.alwaysOriginal)
        
        for tabBarItem in tabBar.items! {
            tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            tabBarItem.title = nil
        }
        
        UITabBar.appearance().backgroundImage = #colorLiteral(red: 0.9953911901, green: 0.9881951213, blue: 1, alpha: 0.1007922535).image()
        UITabBar.appearance().shadowImage = UIImage()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        middleButtonBackgroundImageView.image = #imageLiteral(resourceName: "Union2")
        
        tabBar.addSubview(middleButtonBackgroundImageView)
        tabBar.sendSubviewToBack(middleButtonBackgroundImageView)
        
        middleButtonBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        middleButtonBackgroundImageView.topAnchor.constraint(equalTo: tabBar.topAnchor,
                                                             constant: 6).isActive = true
        middleButtonBackgroundImageView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor,
                                                                constant: -(6 + view.safeAreaInsets.bottom)).isActive = true
        middleButtonBackgroundImageView.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor).isActive = true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        middleButtonBackgroundImageView.image
            = item == tabBar.items![1]
            ?  #imageLiteral(resourceName: "Union2")
            :  #imageLiteral(resourceName: "Union")
    }
    
    // MARK: - UITabBarControllerDelegate -
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        CustomTransition(viewControllers: tabBarController.viewControllers)
    }
}

fileprivate extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
