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
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        let locationModel = LocationModel(latitude: newLocation.coordinate.latitude.description,
                                          longitude: newLocation.coordinate.longitude.description)
        NetworkManager.getSunData(location: locationModel, day: .today) { result in
            switch result {
            case let .success(sunModel):
                print(DatesConverter.formatDateToHHmm(date: sunModel.sunrise))
                print(DatesConverter.formatDateToHHmm(date: sunModel.sunset))
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
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
