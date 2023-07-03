//
//  AboutView.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AboutView: UIView, UIScrollViewDelegate {

    struct Model {
        let logo: UIImage
        let name: String
        let appVersion: String?
        let legalItems: [ItemView.Model]
        let socialItems: [ItemView.Model]
        let coauthors: [ItemView.Model]
        let feedbackItems: [ItemView.Model]
    }
    private var model: Model
    private var selectionHandler: ((AboutIdentifier) -> Void)?

    // MARK: - Subviews

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.boldBigTitle)
        return label
    }()

    private lazy var appVersionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.applyStyle(.description)
        return label
    }()

    private lazy var legalVStack = newStack

    private lazy var socialVStack = newStack

    private lazy var coauthorsVStack = newStack

    private lazy var feedbackVStack = newStack

    private var newStack: UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.clipsToBounds = true
        stack.layer.applyStyle(.usualBorder)
        return stack
    }

    private lazy var VStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.clipsToBounds = true
        stack.spacing = 20
        return stack
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    // MARK: - LifeCycle

    init(model: Model,
         selectionHandler: @escaping (AboutIdentifier) -> Void
    ) {
        self.model = model
        self.selectionHandler = selectionHandler
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        addBackgroundView()
        addSubviews(
            scrollView.addSubviews(

                contentView.addSubviews(
                    logoImageView,
                    nameLabel,
                    appVersionLabel,

                    VStack.addArrangedSubviews(

                        legalVStack.addArrangedSubviews(
                            model.legalItems.map { [weak self] model in
                                ItemView(model: model) {
                                    self?.selectionHandler?(model.identifier)
                                }
                            },
                            separated: true
                        ),

                        socialVStack.addArrangedSubviews(
                            model.socialItems.map { [weak self] model in
                                ItemView(model: model) {
                                    self?.selectionHandler?(model.identifier)
                                }
                            },
                            separated: true
                        ),

                        coauthorsVStack.addArrangedSubviews(
                            model.coauthors.map { [weak self] model in
                                ItemView(model: model) {
                                    self?.selectionHandler?(model.identifier)
                                }
                            },
                            separated: true
                        ),

                        feedbackVStack.addArrangedSubviews(
                            model.feedbackItems.map { [weak self] model in
                                ItemView(model: model) {
                                    self?.selectionHandler?(model.identifier)
                                }
                            },
                            separated: true
                        )
                    )
                )
            )
        )

        logoImageView.image = model.logo

        nameLabel.text = model.name

        if let appVersion = model.appVersion {
            appVersionLabel.text = appVersion
        } else {
            appVersionLabel.isHidden = true
        }
    }

    func deselectAll() {
        VStack.arrangedSubviews.forEach { view in
            if let stack = view as? UIStackView {
                stack.arrangedSubviews.forEach { view in
                    if let view = view as? ItemView {
                        view.drawSelection(false)
                    }
                }
            }
        }
    }

    // MARK: - Layout

    private func setupLayout() {
        logoImageView.activateConstraints(
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        )
        nameLabel.activateConstraints(
            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        )
        appVersionLabel.activateConstraints(
            appVersionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            appVersionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        )
        scrollView.activateConstraints(
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        )
        contentView.activateConstraints(
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        )
        VStack.activateConstraints(
            VStack.topAnchor.constraint(equalTo: appVersionLabel.bottomAnchor, constant: 20),
            VStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            VStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            VStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            VStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -40)
        )
        VStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
            )
        }
        legalVStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
            )
        }
        socialVStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
            )
        }
        coauthorsVStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
            )
        }
        feedbackVStack.arrangedSubviews.forEach { view in
            view.activateConstraints(
                view.widthAnchor.constraint(equalTo: VStack.widthAnchor)
            )
        }
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        deselectAll()
    }
}
