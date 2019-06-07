//
//  Transition.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import SPStorkController

class TransitionManager {
    
    // MARK: Properties
    var storyboard = UIStoryboard(name: Storyboard.name, bundle: nil)
    
    // MARK: Methods
    func makeTransition(from senderController: UIViewController, to controllerID: String) {
        
        let controller = storyboard.instantiateViewController(withIdentifier: controllerID)
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        
        if senderController is SPStorkControllerDelegate {
            transitionDelegate.storkDelegate = senderController as? SPStorkControllerDelegate
        }
        
        senderController.present(controller, animated: true, completion: nil)
    }
    
}

extension ProgressViewController: SPStorkControllerDelegate {
}
