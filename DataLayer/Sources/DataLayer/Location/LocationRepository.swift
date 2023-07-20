import Core
import CoreLocation

public protocol LocationRepository {
    func get(permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
             _ completion: @escaping (Result<CLLocation, Error>) -> Void
    )
}
