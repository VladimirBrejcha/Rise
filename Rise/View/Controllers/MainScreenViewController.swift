//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    // MARK: Properties
    private var transtitionManager: TransitionManager?

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transtitionManager = TransitionManager()
        transtitionManager?.makeTransition(from: self, to: Identifiers.sleep)
    }
    
}
