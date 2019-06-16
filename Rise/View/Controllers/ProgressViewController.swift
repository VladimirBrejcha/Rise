//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ProgressViewController: UIViewController {
    
    // MARK: Properties
    var transitionManager: TransitionManager? {
        return TransitionManager(self)
    }
    var bannerManager: BannerManager? {
        return BannerManager(title: "Saved", style: .success)
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func changeButtonTouch(_ sender: UIButton) {
        transitionManager?.makeTransition(to: Identifiers.personal)
    }
    
    func didDismissStorkBySwipe() {
        transitionManager?.dismissController()
        bannerManager?.banner.show()
    }
    
}
