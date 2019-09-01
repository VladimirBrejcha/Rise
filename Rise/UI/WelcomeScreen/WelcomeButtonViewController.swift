//
//  WelcomeButtonViewController.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class WelcomeButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func startButtonPressed(_ sender: UIButton) {
        UserDefaults.welcomeScreenBeenShowed = true
    }

}
