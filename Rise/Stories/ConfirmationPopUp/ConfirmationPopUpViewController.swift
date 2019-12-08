//
//  ConfirmationPopUpViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class ConfirmationPopUpViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func skipTouchUp(_ sender: Button) {
        self.dismiss(animated: true, completion: nil)
    }
}
