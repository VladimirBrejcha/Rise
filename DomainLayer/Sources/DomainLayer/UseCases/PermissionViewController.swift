import Foundation
import UIKit

class PermissionViewController: UIViewController {
    var notifyToSleep: NotifyToSleep?
    private var blurView: UIVisualEffectView!
    private let animationDuration: TimeInterval = 0.3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView = addBackgroundView(.dark)
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
    }
    
    private func addBackgroundView(_ style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        return blurView
    }
    
    private func showNotificationAlert() {
        let title = "Rise"
        let message =  """
      Good Night! 🌙
      We noticed that you haven't enabled notifications for Rise yet. We're here to make sure you wake up on time and start your day right!
      For us to do that effectively, we need you to allow notifications. This ensures that we can sound your alarm even when the app isn't actively running. It's an easy one-time setup in your device's settings.
      Will you help us, help you rise and shine every morning? ☀️
  """
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { _ in
            UIApplication.openAppSettings()
        }
        let skipAction =  UIAlertAction(title: "Not Now", style: .cancel) { _ in
            self.dismiss(animated: true)
        }
        ac.addAction(goToSettingsAction)
        ac.addAction(skipAction)
        present(ac, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showNotificationAlert()
    }
}
