//
//  DefaultLocationRepository.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

final class DefaultLocationRepository: LocationRepository {
    private let localDataSource: LocationLocalDataSource
    private let remoteDataSource: LocationRemoteDataSource
    
    init(_ localDataSource: LocationLocalDataSource, _ remoteDataSource: LocationRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func get(_ completion: @escaping (Result<Location, Error>) -> Void) {
        do {
            if let storedLocation = try localDataSource.get() {
                completion(.success(storedLocation))
                return
            }
            
            remoteDataSource.requestPermissions { [weak self] granted in
                guard let self = self else { return }
                guard granted else {
                    completion(.failure(PermissionError.locationAccessDenied))
                    return
                }
                
                self.remoteDataSource.get { result in
                    if case .success (let location) = result {
                        self.refreshStoredData(location)
                        completion(.success(location))
                    }
                    if case .failure (let error) = result {
                        completion(.failure(error))
                    }
                }
            }
            
        } catch (let error) {
            completion(.failure(error))
        }
    }
    
    func save(location: Location) throws {
        try localDataSource.save(location: location)
    }
    
    func deleteAll() throws {
        try localDataSource.deleteAll()
    }
    
    private func refreshStoredData(_ location: Location) {
        do {
            try self.deleteAll()
            try self.save(location: location)
        } catch (let error) {
            log(.error, with: error.localizedDescription)
        }
    }
}
