//
//  CustomTabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
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

    convenience init(items: [UIViewController], selectedIndex: Int) {
        self.init(nibName: nil, bundle: nil)
        self.viewControllers = items
        self.selectedIndex = selectedIndex
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.standardAppearance = appeareance
        delegate = self
    }

    private func makeItemAppearance(for style: UITabBarItemAppearance.Style) -> UITabBarItemAppearance {
        let appearance = UITabBarItemAppearance(style: style)
        appearance.configureWithDefault(for: style)
        appearance.applyStyle(.usual)
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
