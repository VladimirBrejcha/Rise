//
//  RefreshSunTimesViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class RefreshSunTimesViewController:
    UIViewController,
    LocationPermissionAlertPresentable,
    AlertCreatable
{
    private let refreshSunTime: RefreshSunTime
    private var refreshSunTimeView: RefreshSunTimesView {
        view as! RefreshSunTimesView
    }

    // MARK: - LifeCycle

    init(refreshSunTime: RefreshSunTime) {
        self.refreshSunTime = refreshSunTime
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = RefreshSunTimesView(
            refreshHandler: { [weak self] in
                self?.refreshSunTimeView.showLoading()
                self?.refreshSunTime(
                    permissionRequestProvider: { [weak self] openSettingsHandler in
                        DispatchQueue.main.async {
                            self?.presentLocationPermissionAccessAlert { didOpenSettings in
                                openSettingsHandler(didOpenSettings)
                            }
                        }
                    },
                    onSuccess: {
                        self?.refreshSunTimeView.showDone()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self?.dismiss(animated: true)
                        }
                    },
                    onFailure: { error in
                        if error as? PermissionError == PermissionError.locationAccessDenied {
                            self?.refreshSunTimeView.showPermissionDeniedError()
                        } else {
                            self?.refreshSunTimeView.showError()
                        }
                    }
                )
            },
            closeHandler: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
    }
}
