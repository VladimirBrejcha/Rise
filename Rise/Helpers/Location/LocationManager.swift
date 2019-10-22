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
    private var requestLocationCompletion: ((Result<LocationModel, Error>) -> Void)?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestNewLocation(with completion:  @escaping (Result<LocationModel, Error>) -> Void) {
        requestLocationCompletion = completion
        locationManager.requestLocation()
    }
    
    func requestPermissions() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let completion = requestLocationCompletion else { return }
        if let newLocation = locations.last
        {
            let locationModel = LocationModel(latitude: newLocation.coordinate.latitude.description,
                                              longitude: newLocation.coordinate.longitude.description)
            completion(.success(locationModel))
        }
        else { completion(.failure(RiseError.errorNoLocationArrived())) }
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
