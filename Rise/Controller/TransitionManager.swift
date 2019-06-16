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
    private var storyboard: UIStoryboard {
        return UIStoryboard(name: Storyboard.name, bundle: nil)
    }
    
    var senderController: UIViewController
    
    init(_ senderController: UIViewController) {
        self.senderController = senderController
    }
    
    // MARK: Methods
    public func makeTransition(to recieverControllerID: String) {
        
        let controller = storyboard.instantiateViewController(withIdentifier: recieverControllerID)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.senderController.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
        }) { _ in
            
            let transitionDelegate = SPStorkTransitioningDelegate()
            
            controller.transitioningDelegate = transitionDelegate
            controller.modalPresentationStyle = .custom
            
            if self.senderController is SPStorkControllerDelegate {
                transitionDelegate.storkDelegate = self.senderController as? SPStorkControllerDelegate
            }
            
            self.senderController.present(controller, animated: true)
        }
    }
    
    func dismissController() {
        UIView.animate(withDuration: 2,
                       delay: 0,
                       options: .allowUserInteraction,
                       animations: {
                        self.senderController.view.backgroundColor = .clear
        })
    }
    
}

// MARK: Extensions
extension ProgressViewController: SPStorkControllerDelegate {
}

extension MainScreenViewController: SPStorkControllerDelegate {
}
