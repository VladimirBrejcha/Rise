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
    var transitionManager: TransitionManager?
    var bannerManager: BannerManager!
    
    // MARK: IBOutlets
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: UISetup Methods
    
    // MARK: Actions
    @IBAction func changeButtonTouch(_ sender: UIButton) {
        transitionManager = TransitionManager()
        transitionManager?.makeTransition(from: self, to: Identifiers.personal)
    }
    
    func didDismissStorkBySwipe() {
        bannerManager = BannerManager(title: "Saved", style: .success)
        bannerManager?.banner.show()
    }
    
}
