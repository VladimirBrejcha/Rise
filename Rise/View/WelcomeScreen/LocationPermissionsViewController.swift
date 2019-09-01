//
//  LocationPermissionsViewController.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class LocationPermissionsViewController: UIViewController, LocationPermissionsProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        sharedLocationManager.permissionsDelegate = self
    }
    
    func permissionsGranted(granted: Bool) {
    }

}
