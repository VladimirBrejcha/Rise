//
//  PermissionView.swift
//  Rise
//
//  Created by Артем Чжен on 22/07/23.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView
import Localization

class PermissionView: UIView {
    private let goToSettingsAction: () -> Void
    private let skipAction: () -> Void
    

    
    lazy var titleLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
           label.textColor = .white
           label.textAlignment = .center
           label.text = "Enable Notifications"
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       lazy var moonImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(systemName: "moon.zzz.fill")
           imageView.tintColor = .white
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
       
       lazy var messageLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           label.textColor = .white
           label.textAlignment = .center
           label.numberOfLines = 0
           label.text = """
               Good Night! 🌙
               We noticed that you haven't enabled notifications for Rise yet. We're here to make sure you wake up on time and start your day right!
               For us to do that effectively, we need you to allow notifications. This ensures that we can sound your alarm even when the app isn't actively running. It's an easy one-time setup in your device's settings.
               Will you help us, help you rise and shine every morning? ☀️
               """
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       lazy var goToSettingsButton: Button = {
           let button = Button()
           button.setTitle("Go to Settings", for: .normal)
           button.style = .primary
           button.onTouchUp = { [weak self] in
               self?.goToSettingsAction()
           }
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
    lazy var skipButton: Button = {
        let button = Button()
        button.setTitle("Not Now", for: .normal)
        button.applyStyle(.secondary)
        button.onTouchUp = { [weak self] in
            self?.skipAction()
        }
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
    init(goToSettingsAction: @escaping () -> Void, skipAction: @escaping () -> Void) {
        self.goToSettingsAction = goToSettingsAction
        self.skipAction = skipAction
        super.init(frame: .zero)
           setupView()
           setupLayout()
       }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
       
       private func setupView() {
           addBackgroundView(.rich, blur: .dark)
           backgroundColor = .clear
           addSubview(titleLabel)
           addSubview(moonImageView)
           addSubview(messageLabel)
           addSubview(goToSettingsButton)
           addSubview(skipButton)
       }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        goToSettingsButton.layer.cornerRadius = goToSettingsButton.bounds.height / 2
        skipButton.layer.cornerRadius = skipButton.bounds.height / 2
    }
       
       private func setupLayout() {
           NSLayoutConstraint.activate([
            moonImageView.topAnchor.constraint(equalTo:  safeAreaLayoutGuide.topAnchor, constant: 40),
            moonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            moonImageView.widthAnchor.constraint(equalToConstant: 80),
            moonImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            goToSettingsButton.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -10),
            goToSettingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            goToSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            skipButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
           ])
       }
}
