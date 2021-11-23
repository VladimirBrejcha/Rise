//  
//  KeepAppOpenedSuggestionViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class KeepAppOpenedSuggestionViewController: UIViewController {

    private var loadedView: KeepAppOpenedSuggestionView {
        view as! KeepAppOpenedSuggestionView
    }

    private let completion: (() -> Void)?

    // MARK: - LifeCycle

    init(completion: (() -> Void)?) {
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = KeepAppOpenedSuggestionView(
            continueHandler: { [weak self] in
                self?.dismiss(
                    animated: true,
                    completion: self?.completion
                )
            }
        )
    }
}
