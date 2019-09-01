//
//  UIHelper.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class UIHelper {
    class func showError(errorMessage: String, customTitle: String? = nil, action: UIAlertAction? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController?.toppestViewController else { return }
        
        let alert = UIAlertController(title: customTitle ?? "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        if let alertAction = action { alert.addAction(alertAction) }
        controller.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
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

extension UIStoryboard { // used to call controllers with same id as a view controller type
    func instantiateViewController(withIdentifier typeIdentifier: UIViewController.Type) -> UIViewController {
        return instantiateViewController(withIdentifier: String(describing: typeIdentifier))
    }
}
extension UIViewController { // used to call segues with same id as a view controller type
    func performSegue(withIdentifier typeIdentifier: UIViewController.Type, sender: Any?) {
        return performSegue(withIdentifier: String(describing: typeIdentifier), sender: sender)
    }
}

extension UIColor { //allows to create UIImage from UIColor
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
