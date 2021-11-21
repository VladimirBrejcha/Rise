//
//  DefaultLocationRepository.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

final class DefaultLocationRepository: LocationRepository {
    private let localDataSource: LocationLocalDataSource
    private let remoteDataSource: LocationRemoteDataSource
    
    init(_ localDataSource: LocationLocalDataSource, _ remoteDataSource: LocationRemoteDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }
    
    func get(
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        _ completion: @escaping (Result<Location, Error>) -> Void
    ) {
        log(.info)
        do {
            if let storedLocation = try localDataSource.get() {
                log(.info, "found stored location: \(storedLocation)")
                completion(.success(storedLocation))
                return
            }
            
            remoteDataSource.requestPermissions(
                permissionRequestProvider: permissionRequestProvider
            ) { [weak self] granted in
                guard let self = self else { return }
                guard granted else {
                    log(.warning, "access denied")
                    completion(.failure(PermissionError.locationAccessDenied))
                    return
                }
                
                self.remoteDataSource.get { result in
                    if case .success (let location) = result {
                        self.save(location: location)
                        log(.info, "got location: \(location)")
                        completion(.success(location))
                    }
                    if case .failure (let error) = result {
                        log(.warning, "got an error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
            
        } catch (let error) {
            log(.warning, "got an error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    private func save(location: Location) {
        log(.info, "location: \(location)")

        do {
            try localDataSource.save(location: location)
        } catch (let error) {
            assertionFailure(error.localizedDescription)
            log(.error, "deleting error: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        log(.info)

        do {
            try localDataSource.deleteAll()
        } catch (let error) {
            assertionFailure(error.localizedDescription)
            log(.error, "deleting error: \(error.localizedDescription)")
        }
    }
}
