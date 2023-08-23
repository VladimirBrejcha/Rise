//
//  TabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private lazy var backgroundView = Background.default.asUIView

    private lazy var appearance: UITabBarAppearance = {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedItemPositioning = .fill
        appearance.compactInlineLayoutAppearance = makeItemAppearance(for: .compactInline)
        appearance.inlineLayoutAppearance = makeItemAppearance(for: .inline)
        appearance.stackedLayoutAppearance = makeItemAppearance(for: .stacked)
        return appearance
    }()

    init(items: [UIViewController], selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = items
        self.selectedIndex = selectedIndex
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        delegate = self

        view.addSubviews(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.activateConstraints {
            [$0.heightAnchor.constraint(equalTo: view.heightAnchor),
            $0.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 100),
            $0.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            $0.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        }
    }

    private func makeItemAppearance(
        for style: UITabBarItemAppearance.Style
    ) -> UITabBarItemAppearance {
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
        ScrollTransition(
            viewControllers: tabBarController.viewControllers,
            backgroundView: backgroundView,
            backgroundTranslationX: 50
        )
    }
}
