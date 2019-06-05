//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import MKRingProgressView

class NewViewController: UIViewController {

    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ringProgressView.startColor = #colorLiteral(red: 0.8830604553, green: 0.1576697826, blue: 0.4471456409, alpha: 1)
        ringProgressView.endColor = #colorLiteral(red: 0.8830604553, green: 0.1576697826, blue: 0.4471456409, alpha: 1)
        ringProgressView.backgroundRingColor = #colorLiteral(red: 0.7176470588, green: 0.6156862745, blue: 0.7450980392, alpha: 1)
        ringProgressView.ringWidth = 25
        ringProgressView.progress = 0.2
        ringProgressView.shadowOpacity = 1
        
        label.text = "sefsdfsef"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.ringProgressView.progress = 1.0
        }
    }

}
