//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    private typealias Colors = Styles.TabBar.Color
    private lazy var appeareance: UITabBarAppearance = {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundImage = #imageLiteral(resourceName: "tabBarBack")
        appearance.stackedItemPositioning = .fill
        appearance.compactInlineLayoutAppearance = makeItemAppearance(for: .compactInline)
        appearance.inlineLayoutAppearance = makeItemAppearance(for: .inline)
        appearance.stackedLayoutAppearance = makeItemAppearance(for: .stacked)
        return appearance
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [Story.plan(), Story.today(), Story.settings()]
        selectedIndex = 1
        tabBar.standardAppearance = appeareance
        delegate = self
    }

    private func makeItemAppearance(for style: UITabBarItemAppearance.Style) -> UITabBarItemAppearance {
        let appearance = UITabBarItemAppearance(style: style)
        appearance.configureWithDefault(for: style)
        appearance.normal.iconColor = Colors.Icon.normal
        appearance.normal.titleTextAttributes = [.foregroundColor: Colors.Title.normal]
        appearance.selected.titleTextAttributes = [.foregroundColor: Colors.Title.selected]
        appearance.selected.iconColor = Colors.Icon.selected
        return appearance
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
