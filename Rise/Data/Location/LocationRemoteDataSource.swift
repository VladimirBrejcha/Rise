//
//  GenericDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
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
        UIHelper.showAlert(with: error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let completion = requestPermissionsCompletion else { return }
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: completion(true)
        case .notDetermined: requestPermissions(with: completion); return
        case .denied, .restricted: askForLocationPermissions(completion: completion)
        default: completion(false)
        }
    }
    
    private func askForLocationPermissions(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "Location access denied", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            completion(false)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        UIHelper.show(alertController: alertController)
    }
}
