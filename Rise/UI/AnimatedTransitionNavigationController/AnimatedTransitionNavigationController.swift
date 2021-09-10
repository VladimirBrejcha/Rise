//
//  AnimatedTransitionNavigationController.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.10.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AnimatedTransitionNavigationController:
    UINavigationController,
    UINavigationControllerDelegate
{
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sharedInit()
    }
    
    init() {
        super.init(rootViewController: UIViewController())
        sharedInit()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
        setNavigationBarHidden(true, animated: false)
        delegate = self
    }
    
    // MARK: - UINavigationControllerDelegate -
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        AnimatedTransition()
    }
}
