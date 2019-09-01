//
//  LocationPermissionsViewController.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class LocationPermissionsViewController: UIViewController, LocationPermissionsProtocol {
    let locationManager = sharedLocationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sharedLocationManager.permissionsDelegate = self
    }
    
    func permissionsGranted(granted: Bool) {
        if granted {
            print("granted")
        } else {
            print("not granted")
        }
    }
    
    @IBAction func requestPermissionButtonPressed(_ sender: UIButton) {
        locationManager.requestPermissions()
    }
    
}
