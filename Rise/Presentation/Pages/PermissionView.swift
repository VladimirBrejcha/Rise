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
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var goToSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go to Settings", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Not Now", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear

        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(goToSettingsButton)
        addSubview(skipButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            goToSettingsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            goToSettingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            goToSettingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            skipButton.bottomAnchor.constraint(equalTo: goToSettingsButton.topAnchor, constant: -10),
            skipButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
