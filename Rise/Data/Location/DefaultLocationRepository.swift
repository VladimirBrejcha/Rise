//
//  LocationRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

final class DefaultLocationRepository: LocationRepository {
    private let localDataSource: LocationLocalDataSource
    private let remoteDataSource: LocationRemoteDataSource
    
    init(_ localDataSource: LocationLocalDataSource, _ remoteDataSource: LocationRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func get(_ completion: @escaping (Result<Location, Error>) -> Void) {
        do {
            completion(.success(try localDataSource.get()))
        } catch (let error) {
            log(.error, with: error.localizedDescription)
            remoteDataSource.requestPermissions { granted in
                granted
                    ? self.remoteDataSource.get { result in
                        if case .success (let location) = result {
                            do {
                                try self.deleteAll()
                                try self.save(location: location)
                            } catch (let error) {
                                log(.error, with: error.localizedDescription)
                            }
                            completion(.success(location))
                        }
                        if case .failure (let error) = result {
                            completion(.failure(error))
                        }
                      }
                    : completion(.failure(RiseError.locationAccessDenied))
            }
        }
    }
    
    func save(location: Location) throws {
        try localDataSource.save(location: location)
    }
    
    func deleteAll() throws {
        try localDataSource.deleteAll()
    }
}
