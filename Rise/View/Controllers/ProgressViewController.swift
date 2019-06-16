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
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
        }) { _ in
            self.transitionManager = TransitionManager()
            self.transitionManager?.makeTransition(from: self, to: Identifiers.personal)
        }
    }
    
    func didDismissStorkBySwipe() {
        UIView.animate(withDuration: 2) {
            self.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
            self.view.backgroundColor = .clear
        }
        bannerManager = BannerManager(title: "Saved", style: .success)
        bannerManager?.banner.show()
    }
    
}
