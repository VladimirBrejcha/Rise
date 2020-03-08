//
//  UIHelper.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AlertPresenter {
    static func showAlert(with message: String,
                   and customTitle: String? = nil,
                   customAction: UIAlertAction? = nil,
                   cancelHandler: (() -> Void)? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController?.toppestViewController else { return }
        
        let alert = UIAlertController(title: customTitle ?? "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { _ in cancelHandler?() }
        alert.addAction(cancelAction)
        
        if let customAction = customAction { alert.addAction(customAction) }
        
        controller.present(alert, animated: true)
    }
    
    static func show(alertController: UIAlertController) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController?.toppestViewController else { return }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showLocationPermissionsAlert(completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(
            title: "Location access denied",
            message: "Please go to Settings and turn on the permissions",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            completion(false)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        show(alertController: alertController)
    }
}

fileprivate extension UIViewController {
    var topPresentedController: UIViewController {
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topPresentedController
        } else {
            return self
        }
    }
    
    var toppestViewController: UIViewController {
        if let navigationvc = self as? UINavigationController {
            if let navigationsTopViewController = navigationvc.topViewController {
                return navigationsTopViewController.topPresentedController
            } else {
                return navigationvc // no children
            }
        } else if let tabbarvc = self as? UITabBarController {
            if let selectedViewController = tabbarvc.selectedViewController {
                return selectedViewController.topPresentedController
            } else {
                return self // no children
            }
        } else if let firstChild = self.children.first {
            // other container's view controller
            return firstChild.topPresentedController
        } else {
            return self.topPresentedController
        }
    }
}
