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

    convenience init(
        data: [OnboardingView.ContentView.Model],
        setOnboardingCompleted: SetOnboardingCompleted
    ) {
        self.init(nibName: nil, bundle: nil)
        self.data = data
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
                self.navigationController?.popViewController(animated: true)
            }
        )
    }
}
