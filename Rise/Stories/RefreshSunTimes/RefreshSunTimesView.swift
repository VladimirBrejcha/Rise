//
//  RefreshSunTimesView.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

final class RefreshSunTimesView: UIView {

    private let refreshHandler: () -> Void
    private let closeHandler: () -> Void

    // MARK: - Subviews

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Background.default.image
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var closeButton: Button = makeCloseButton(
        handler: { [weak self] in
            self?.closeHandler()
        }
    )

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedTitle)
        label.text = Text.refreshSunTimes
        return label
    }()

    private lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: .zero)
        loadingView.backgroundColor = .clear
        loadingView.state = .info(
            message: """
                     \(Text.refreshSunTimesDescription)

                     \(Text.useRefreshFor)
                     """
        )
        return loadingView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.fill")
        imageView.tintColor = Asset.Colors.white.color
        return imageView
    }()

    private lazy var refreshButton: Button = {
        let button = Button()
        button.setTitle(Text.refresh, for: .normal)
        button.onTouchUp = {
            [weak self] _ in self?.refreshHandler()
        }
        return button
    }()

    // MARK: - LifeCycle

    init(
        refreshHandler: @escaping () -> Void,
        closeHandler: @escaping () -> Void
    ) {
        self.refreshHandler = refreshHandler
        self.closeHandler = closeHandler
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addSubviews(
            backgroundImageView,
            titleLabel,
            closeButton,
            imageView,
            loadingView,
            refreshButton
        )
    }

    // MARK: - Actions
    
    func showLoading() {
        loadingView.state = .loading
        refreshButton.isHidden = true
    }

    func showDone() {
        loadingView.state = .info(message: Text.success)
    }

    func showError() {
        loadingView.state = .info(message: Text.anInternalErrorOccurred)
        refreshButton.isHidden = false
    }

    func showPermissionDeniedError() {
        loadingView.state = .info(message: Text.locationAccessIsRequiredToPerformRefresh)
        refreshButton.isHidden = false
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundImageView.activateConstraints(
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
        titleLabel.activateConstraints(
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: -2)
        )
        closeButton.activateConstraints(
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        )
        imageView.activateConstraints(
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)
        )
        loadingView.activateConstraints(
            loadingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loadingView.heightAnchor.constraint(equalToConstant: 180)
        )
        refreshButton.activateConstraints(
            refreshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            refreshButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        )
    }
}
