//
//  SettingsView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SettingsView: UIView {

    private var models: [SettingItemView.Model] = []
    private var selectionHandler: ((SettingIdentifier) -> Void)?
    private var appVersion: String?

    // MARK: - Subviews

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Background.default.image
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var VStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.clipsToBounds = true
        stack.layer.applyStyle(.usual)
        return stack
    }()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.applyStyle(.description)
        return label
    }()

    // MARK: - LifeCycle

    convenience init(
        models: [SettingItemView.Model],
        selectionHandler: @escaping (SettingIdentifier) -> Void,
        appVersion: String?
    ) {
        self.init(frame: .zero)
        self.models = models
        self.appVersion = appVersion
        self.selectionHandler = selectionHandler
        setup()
    }

    private func setup() {
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        addSubviews(
            backgroundImageView,
            VStack,
            appVersionLabel
        )
        models.forEach { model in
            VStack.addArrangedSubview(
                SettingItemView(
                    model: model,
                    touchHandler: { [weak self] in
                        self?.selectionHandler?(model.identifier)
                    }
                )
            )
        }
        VStack.addSeparators(color: .white)
        if let appVersion = appVersion {
            appVersionLabel.text = "Rise v\(appVersion)"
        }
    }

    func deselectAll() {
        VStack.arrangedSubviews.forEach { view in
            if let view = view as? SettingItemView {
                view.drawSelection(false)
            }
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundImageView.activateConstraints(
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
        VStack.activateConstraints(
            VStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            VStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            VStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        )
        VStack.arrangedSubviews.forEach { view in
            if view is SettingItemView {
                view.activateConstraints(
                    view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
                )
            } else {
                view.activateConstraints(
                    view.widthAnchor.constraint(equalTo: VStack.widthAnchor, constant: -44)
                )
            }
        }
        appVersionLabel.activateConstraints(
            appVersionLabel.topAnchor.constraint(equalTo: VStack.bottomAnchor, constant: 16),
            appVersionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        )
    }
}
