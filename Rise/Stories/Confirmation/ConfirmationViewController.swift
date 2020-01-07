//
//  ConfirmationPopUpViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func resheduleTouchUp(_ sender: Button) {
    }
    
    @IBAction func confirmTouchUp(_ sender: Button) {
        self.dismiss(animated: true, completion: nil)
    }
}
