//
//  SettingsView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SettingsView: UIView {

    private var selectionHandler: ((SettingIdentifier) -> Void)?

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
        stack.layer.applyStyle(.usualBorder)
        stack.backgroundColor = .white.withAlphaComponent(0.05)
        return stack
    }()

    // MARK: - LifeCycle

    convenience init(
        selectionHandler: @escaping (SettingIdentifier) -> Void
    ) {
        self.init(frame: .zero)
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
            VStack
        )
    }

    func reconfigure(with models: [ItemView.Model]) {
        VStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        VStack.addArrangedSubviews(
            models.map { model in
                ItemView(
                    model: model,
                    touchHandler: { [weak self] in
                        self?.selectionHandler?(model.identifier)
                    }
                )
            },
            separated: true
        )
        VStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(
                    equalTo: VStack.widthAnchor,
                    constant: view is ItemView ? 0 : -44
                )
            )
        }
    }

    func deselectAll() {
        VStack.arrangedSubviews.forEach { view in
            if let view = view as? ItemView {
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
    }
}
