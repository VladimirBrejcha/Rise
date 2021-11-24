//  
//  AfterSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AfterSleepViewController: UIViewController {

    private var loadedView: AfterSleepView {
        view as! AfterSleepView
    }

    // MARK: - LifeCycle

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = AfterSleepView(
            doneHandler: { [weak self] in
                self?.dismiss(animated: true)
            },
            appearance: .sleepStopped
        )
    }
}
