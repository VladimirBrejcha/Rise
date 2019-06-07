//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import SPStorkController

class MainScreenViewController: UIViewController {
    
    // MARK: Properties
    var transtitionManager: TranstitionManager?

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transtitionManager = TranstitionManager()
        transtitionManager?.makeTransition(from: self, to: Identifiers.sleep)
    }
    
}
