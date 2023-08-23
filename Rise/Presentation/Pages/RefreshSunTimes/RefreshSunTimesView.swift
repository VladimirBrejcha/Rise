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
import UILibrary

final class RefreshSunTimesView: UIView {

  private let refreshHandler: () -> Void
  private let closeHandler: () -> Void

  // MARK: - Subviews

  private lazy var titleView: UIView = Title.make(
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
      imageView.activateConstraints {
          [$0.heightAnchor.constraint(equalToConstant: 50),
          $0.widthAnchor.constraint(equalToConstant: 50),
          $0.centerXAnchor.constraint(equalTo: centerXAnchor),
          $0.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100)]
      }
      loadingView.activateConstraints {
          [$0.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
          $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
          $0.heightAnchor.constraint(equalToConstant: 180)]
      }
      refreshButton.activateConstraints {
          [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
          $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
          $0.heightAnchor.constraint(equalToConstant: 44),
          $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
      }
  }
}
