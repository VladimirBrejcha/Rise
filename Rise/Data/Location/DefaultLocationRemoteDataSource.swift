//
//  DefaultLocationRemoteDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import CoreLocation

protocol LocationRemoteDataSource {
    func get(_ completion: @escaping (Result<Location, Error>) -> Void)
    func requestPermissions(_ completion: @escaping (Bool) -> Void)
}

final class DefaultLocationRemoteDataSource: NSObject, CLLocationManagerDelegate, LocationRemoteDataSource {
    private let locationManager = CLLocationManager()
    
    private var requestLocationCompletion: ((Result<Location, Error>) -> Void)?
    private var requestPermissionsCompletion: ((Bool) -> Void)?

    private var authorisationStatus: CLAuthorizationStatus?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func get(_ completion: @escaping (Result<Location, Error>) -> Void){
        requestLocationCompletion = completion
        locationManager.requestLocation()
    }
    
    func requestPermissions(_ completion: @escaping (Bool) -> Void) {
        if     authorisationStatus == .notDetermined
            || authorisationStatus == .denied
            || authorisationStatus == .restricted {
            askForLocationPermissions(completion: completion)
        } else {
            requestPermissionsCompletion = completion
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: - CLLocationManagerDelegate -
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
        log(.error, with: error.localizedDescription)
        AlertPresenter.showAlert(with: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let completion = requestPermissionsCompletion else { return }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: completion(true)
        case .notDetermined: requestPermissions(completion); return
        case .denied, .restricted: askForLocationPermissions(completion: completion)
        default: completion(false)
        }
        authorisationStatus = status
    }
    
    // MARK: - Private -
    private func askForLocationPermissions(completion: @escaping (Bool) -> Void) {
        AlertPresenter.showLocationPermissionsAlert(completion: completion)
    }
}
