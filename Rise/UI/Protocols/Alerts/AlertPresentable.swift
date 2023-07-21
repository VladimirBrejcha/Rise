//
//  AlertPresentable.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol LocationPermissionAlertPresentable: AlertPresentable {
    func presentLocationPermissionAccessAlert(_ proceededToSettings: @escaping (Bool) -> Void)
}

extension LocationPermissionAlertPresentable {
    func presentLocationPermissionAccessAlert(_ proceededToSettings: @escaping (Bool) -> Void) {
        presentAlert(
            text: "Location access",
            description: "'Rise' requires access to your location to calculate accurate sunrise and sunset times for your area. This information is displayed on the main screen and is used to compare with your personal sleep schedule times, allowing you to align your routines with natural daylight hours. Please note, we only access your location data when the app is in use and do not share this data with any third parties.",
            actions: [
                .init(
                    title: "Ok",
                    style: .default,
                    handler: { _ in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            proceededToSettings(true)
                            UIApplication.shared.open(url)
                        }
                    }
                ),
                .init(
                    title: "Cancel",
                    style: .cancel,
                    handler: { _ in
                        proceededToSettings(false)
                    }
                )
            ]
        )
    }
}

protocol AlertPresentable: AnyObject {
    func presentAlert(from error: Error)
    func presentAlert(
        text: String,
        description: String,
        actions: [UIAlertAction]
    )
    func presentAreYouSureAlert(text: String, action: UIAlertAction)
}

extension AlertPresentable where Self: AlertCreatable & UIViewController {
    func presentAlert(from error: Error) {
        present(makeAlert(for: error), animated: true)
    }

    func presentAreYouSureAlert(text: String, action: UIAlertAction) {
        present(makeAreYouSureAlert(text: text, action: action), animated: true)
    }

    func presentAlert(
        text: String,
        description: String,
        actions: [UIAlertAction]
    ) {
        present(makeAlert(
            title: text,
            message: description,
            actions: actions
        ), animated: true)
    }
}
