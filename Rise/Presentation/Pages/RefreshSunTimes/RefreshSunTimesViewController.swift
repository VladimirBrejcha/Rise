//
//  RefreshSunTimesViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer

final class RefreshSunTimesViewController:
    UIViewController,
    LocationPermissionAlertPresentable,
    AlertCreatable,
    ViewController
{
  enum OutCommand {
    case finish
  }

  typealias Deps = HasRefreshSunTimeUseCase
  typealias View = RefreshSunTimesView

  private let refreshSunTime: RefreshSunTime
  private let out: Out

  // MARK: - LifeCycle

  init(deps: Deps, out: @escaping Out) {
    self.refreshSunTime = deps.refreshSunTime
    self.out = out
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    self.view = View(
      refreshHandler: { [unowned self] in
        rootView.showLoading()
        refreshSunTime(
          permissionRequestProvider: { [weak self] openSettingsHandler in
            DispatchQueue.main.async {
              self?.presentLocationPermissionAccessAlert { didOpenSettings in
                openSettingsHandler(didOpenSettings)
              }
            }
          },
          onSuccess: { [weak self] in
            self?.rootView.showDone()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // TODO: Why?
              self?.out(.finish)
            }
          },
          onFailure: { [weak self] error in
            if error as? PermissionError == PermissionError.locationAccessDenied {
              self?.rootView.showPermissionDeniedError()
            } else {
              self?.rootView.showError()
            }
          }
        )
      },
      closeHandler: { [unowned self] in
        out(.finish)
      }
    )
  }
}
