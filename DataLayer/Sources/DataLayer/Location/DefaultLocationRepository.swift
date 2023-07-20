import Core
import CoreLocation

final class DefaultLocationRepository: LocationRepository {

    private let remoteDataSource: LocationDeviceDataSource

    init(_ remoteDataSource: LocationDeviceDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func get(permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
             _ completion: @escaping (Result<CLLocation, Error>) -> Void
    ) {
        log(.info)

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
                    log(.info, "got location: \(location)")
                    completion(.success(location))
                }
                if case .failure (let error) = result {
                    log(.warning, "got an error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }
    }
}
