//
//  PermissonViewController.swift
//  Rise
//
//  Created by Артем Чжен on 22/07/23.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//
import UIKit
import LoadingView
import Core
import Localization

class PermissionViewController: UIViewController, ViewController {
    typealias View = PermissionView
    
    var goToSettingsAction: (() -> Void)?
    var skipAction: (() -> Void)?
    
    override func loadView() {
        super.loadView()
        self.view = PermissionView()
        if let permissionView = view as? PermissionView {
            permissionView.goToSettingsButton.addTarget(self, action: #selector(goToSettingsTapped), for: .touchUpInside)
            permissionView.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc  func goToSettingsTapped() {
        goToSettingsAction?()
    }
    
    @objc  func skipButtonTapped() {
        skipAction?()
    }
}
