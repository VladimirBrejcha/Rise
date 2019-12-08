//
//  UIHelper.swift
//  Rise
//
//  Created by Владимир Королев on 01/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class UIHelper {
    class func showAlert(with message: String,
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
    
    class func show(alertController: UIAlertController) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController?.toppestViewController else { return }
        controller.present(alertController, animated: true, completion: nil)
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

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
