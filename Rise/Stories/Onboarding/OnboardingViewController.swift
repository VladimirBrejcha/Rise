//
//  OnboardingViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    private var onboardingView: OnboardingView { view as! OnboardingView }
    private var setOnboardingCompleted: SetOnboardingCompleted!
    private var data: [OnboardingView.ContentView.Model] = []
    private var dismissOnCompletion: Bool = false

    convenience init(
        data: [OnboardingView.ContentView.Model],
        setOnboardingCompleted: SetOnboardingCompleted,
        dismissOnCompletion: Bool = false
    ) {
        self.init(nibName: nil, bundle: nil)
        self.data = data
        self.dismissOnCompletion = dismissOnCompletion
        self.setOnboardingCompleted = setOnboardingCompleted
    }

    override func loadView() {
        super.loadView()
        self.view = OnboardingView(
            content: data,
            buttonTitle: Text.Onboarding.action,
            finalButtonTitle: Text.Onboarding.actionFinal,
            completedHandler: { [weak self] in
                guard let self = self else { return }
                self.setOnboardingCompleted(true)
                if self.dismissOnCompletion {
                    self.dismiss(animated: true)
                } else {
                    self.navigationController?.setViewControllers([Story.tabBar()], animated: true)
                }
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }
}
