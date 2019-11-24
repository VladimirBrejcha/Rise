//
//  LocationRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class LocationRepository {
    private let local = LocationLocalDataSource()
    private lazy var remote = LocationRemoteDataSource()
    
    func requestLocation(completion: @escaping (Result<Location, Error>) -> Void) {
        switch local.requestLocation() {
        case .success(let location):
            completion(.success(location))
        case .failure(let error):
            log(error.localizedDescription)
            remote.requestPermissions { granted in
                if granted {
                    self.remote.requestLocation { result in
                        if case .failure (let error) = result { completion(.failure(error)) }
                        if case .success (let location) = result {
                            self.create(location: location)
                            completion(.success(location))
                        }
                    }
                } else {
                    completion(.failure(RiseError.errorLocationAccessDenied()))
                }
            }
        }
    }
    
    @discardableResult func create(location: Location) -> Bool {
        local.create(location: location)
    }
    
    @discardableResult func removeLocation() -> Bool {
        local.deleteAll()
    }
}
