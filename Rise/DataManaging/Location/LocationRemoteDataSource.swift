//
//  GenericDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationRemoteDataSource: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    private var requestLocationCompletion: ((Result<Location, Error>) -> Void)?
    private var requestPermissionsCompletion: ((Bool) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(with completion: @escaping (Result<Location, Error>) -> Void) {
        requestLocationCompletion = completion
        locationManager.requestLocation()
    }
    
    func requestPermissions(with completion: @escaping (Bool) -> Void) {
        requestPermissionsCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let completion = requestLocationCompletion else { return }
        
        if let newLocation = locations.last
        {
            let locationModel = Location(latitude: newLocation.coordinate.latitude.description,
                                              longitude: newLocation.coordinate.longitude.description)
            completion(.success(locationModel))
        }
        else { completion(.failure(RiseError.errorNoLocationArrived())) }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log(error.localizedDescription)
        UIHelper.showError(errorMessage: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let completion = requestPermissionsCompletion else { return }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse : completion(true)
        case .notDetermined : requestPermissions(with: completion); return
        default: completion(false)
        }
        
    }
}
