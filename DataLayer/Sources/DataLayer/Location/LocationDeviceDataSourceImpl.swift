import CoreLocation
import Core

protocol LocationDeviceDataSource {
    func get(_ completion: @escaping (Result<CLLocation, Error>) -> Void)
    func requestPermissions(
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        _ completion: @escaping (Bool) -> Void
    )
}

final class LocationDeviceDataSourceImpl:
    NSObject,
    CLLocationManagerDelegate,
    LocationDeviceDataSource
{
    private let locationManager = CLLocationManager()
    private var requestPermissionsCompletion: ((Bool) -> Void)?
    private var requestLocationCompletion: ((Result<CLLocation, Error>) -> Void)?
    private var permissionRequestProvider: (() -> Void)?
    @UserDefault("authorization_status")
    private var authorizationStatusStorage: Int32?
    private var authorizationStatus: CLAuthorizationStatus? {
        get {
            if let status = authorizationStatusStorage {
                return .init(rawValue: status)
            }
            return nil
        }
        set {
            authorizationStatusStorage = newValue?.rawValue
        }
    }

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func get(_ completion: @escaping (Result<CLLocation, Error>) -> Void) {
        log(.info)
        requestLocationCompletion = completion
        locationManager.requestLocation()
    }

    func requestPermissions(
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        _ completion: @escaping (Bool) -> Void
    ) {
        log(.info, "current status = \(String(describing: authorizationStatus?.rawValue))")
        if authorizationStatus == nil {
            requestPermissionsCompletion = completion
            locationManager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .notDetermined
                    || authorizationStatus == .denied
                    || authorizationStatus == .restricted {
            requestPermissionsCompletion = completion
            permissionRequestProvider { [weak self] proceedToSettings in
                if !proceedToSettings {
                    self?.requestPermissionsCompletion?(false)
                    self?.requestPermissionsCompletion = nil
                }
            }
        } else {
            completion(true)
        }
    }

    //MARK: - CLLocationManagerDelegate -

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log(.info)
        guard let completion = requestLocationCompletion else { return }

        if let newLocation = locations.last {
            completion(.success(newLocation))
        } else {
            completion(.failure(NetworkError.noDataReceived))
        }
        requestLocationCompletion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log(.error, error.localizedDescription)
        requestPermissionsCompletion?(false)
        requestPermissionsCompletion = nil
    }

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        guard let completion = requestPermissionsCompletion else { return }
        
        log(.info, "status = \(status.rawValue)")
        authorizationStatus = status

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        default:
            completion(false)
        }
        requestPermissionsCompletion = nil
    }
}
