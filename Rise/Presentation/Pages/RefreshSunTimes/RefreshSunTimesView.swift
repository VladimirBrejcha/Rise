//
//  RefreshSunTimesView.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView
import Localization

final class RefreshSunTimesView: UIView {

  private let refreshHandler: () -> Void
  private let closeHandler: () -> Void

  // MARK: - Subviews

  private lazy var titleView: UIView = View.Title.make(
    title: Text.refreshSunTimes,
    closeButton: .default { [weak self] in
      self?.closeHandler()
    }
  )
  
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
    button.onTouchUp = { [weak self] in
      self?.refreshHandler()
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
    addBackgroundView()
    addScreenTitleView(titleView)
    addSubviews(
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
      refreshButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
      refreshButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
      refreshButton.heightAnchor.constraint(equalToConstant: 44),
      refreshButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
    )
  }
}
