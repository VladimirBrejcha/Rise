//
//  GenericDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class LocationRemoteDataSource {
    let locationManager = LocationManager()
    
    func requestLocation(completion: @escaping (Result<Location, Error>) -> Void) {
        locationManager.requestLocation(with: completion)
    }
}
