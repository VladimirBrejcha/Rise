//
//  Transition.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import SPStorkController

struct TransitionManager {
    
    // MARK: Properties
    private let storyboard = UIStoryboard(name: Storyboard.name, bundle: nil)
    private var selectedViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabBarController
        return rootViewController?.selectedViewController
    }
    
    // MARK: Methods
    public func makeTransition(to recieverControllerID: String) {

        let controller = storyboard.instantiateViewController(withIdentifier: recieverControllerID)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedViewController?.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
        }) { _ in
            
            let transitionDelegate = SPStorkTransitioningDelegate()
            
            controller.transitioningDelegate = transitionDelegate
            controller.modalPresentationStyle = .custom
            
            if self.selectedViewController is SPStorkControllerDelegate {
                transitionDelegate.storkDelegate = self.selectedViewController as? SPStorkControllerDelegate
            }
            
            self.selectedViewController?.present(controller, animated: true)
        }
    }
    
    public func dismiss(_ controller: UIViewController) {
        controller.dismiss(animated: true) {
            self.animateBackground()
        }
    }
    
    public func animateBackground() {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
                        self.selectedViewController?.view.backgroundColor = .clear
        })
    }
    
}

// MARK: Extensions
extension ProgressViewController: SPStorkControllerDelegate {
}

extension MainScreenViewController: SPStorkControllerDelegate {
}
