//
//  LocationManager.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationPermissionsProtocol: AnyObject {
    func permissionsGranted(granted: Bool)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var permissionsDelegate: LocationPermissionsProtocol?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startSavingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: implementation missing
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        UIHelper.showError(errorMessage: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            permissionsDelegate?.permissionsGranted(granted: true)
        } else {
            permissionsDelegate?.permissionsGranted(granted: false)
        }
    }
}
