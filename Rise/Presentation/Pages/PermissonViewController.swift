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

    private lazy var permissionView: PermissionView = {
        let view = PermissionView(frame: .zero)
        view.titleLabel.text = "Rise"
        view.messageLabel.text = """
               Good Night! 🌙
               We noticed that you haven't enabled notifications for Rise yet. We're here to make sure you wake up on time and start your day right!
               For us to do that effectively, we need you to allow notifications. This ensures that we can sound your alarm even when the app isn't actively running. It's an easy one-time setup in your device's settings.
               Will you help us, help you rise and shine every morning? ☀️
               """
        view.goToSettingsButton.addTarget(self, action: #selector(goToSettingsTapped), for: .touchUpInside)
        view.skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.addBackgroundView (.rich, blur: .dark)
        view.backgroundColor = .clear
        view.addSubview(permissionView)

        NSLayoutConstraint.activate([
            permissionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            permissionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            permissionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            permissionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func goToSettingsTapped() {
        UIApplication.openAppSettings()
    }

    @objc private func skipButtonTapped() {
        dismiss(animated: true)
    }
}
