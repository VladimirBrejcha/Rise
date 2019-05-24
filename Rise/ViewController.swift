//
//  ViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    
}

