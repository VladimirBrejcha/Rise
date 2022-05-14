//
//  NavigationController.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.12.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class NavigationController: UINavigationController, UINavigationControllerDelegate {

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
        self.isNavigationBarHidden = true
        self.delegate = self
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        CrossDissolveTransition()
    }
}
