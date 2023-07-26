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
    
    lazy var titleLabel: UILabel = {
           let label = UILabel()
           label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
           label.textColor = .white
           label.textAlignment = .center
           label.text = "Rise"
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
       
       lazy var goToSettingsButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Go to Settings", for: .normal)
           button.tintColor = .white
           button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
       lazy var skipButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Not Now", for: .normal)
           button.tintColor = .white
           button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
           setupLayout()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           setupView()
           setupLayout()
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
       
       private func setupLayout() {
           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 28),
               titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
               titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
               
               moonImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
               moonImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
               moonImageView.widthAnchor.constraint(equalToConstant: 80),
               moonImageView.heightAnchor.constraint(equalToConstant: 80),
               
               messageLabel.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 16),
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
