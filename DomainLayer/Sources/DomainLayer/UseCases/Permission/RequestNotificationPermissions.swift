import Core
import DataLayer
import UIKit

public protocol HasRequestNotificationPermissions {
    var requestNotificationPermissions: RequestNotificationPermissions { get }
}

public protocol RequestNotificationPermissions {
    @MainActor
    func callAsFunction(askExplicitlyFrom vc: UIViewController) async
}

class RequestNotificationPermissionsImpl: RequestNotificationPermissions {

    var askToOpenSettings: (() -> Void)?

    let manager: NotificationManager
    let userData: UserData

    init(notificationManager: NotificationManager,
         userData: UserData
    ) {
        self.manager = notificationManager
        self.userData = userData
    }

    @MainActor
    func callAsFunction(
        askExplicitlyFrom vc: UIViewController
    ) async {
        switch await manager.isAuthorized() {
        case .notDetermined:
            await manager.requestPermissions()
        case .authorized:
            return
        case .denied:
            if userData.notificationsSuggested { return }
            userData.notificationsSuggested = true
            let askExplicitlyVC = PermissionViewController { command in
                switch command {
                case .goToSettings:
                    UIApplication.openAppSettings()
                case .skip:
                    vc.dismiss(animated: true)
                }
            }
            vc.present(askExplicitlyVC, animated: true)
        }
    }
}

extension UIApplication {
    public static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            log(.error, "Cannot build settings url")
            return
        }
        UIApplication.shared.open(url, options: [:]) { done in
            log(.info, "Open settings request completed = \(done)")
        }
    }
}
