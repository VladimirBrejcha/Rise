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

    private var data: [OnboardingView.ContentView.Model] = []

    convenience init(data: [OnboardingView.ContentView.Model]) {
        self.init(nibName: nil, bundle: nil)
        self.data = data
    }

    override func loadView() {
        super.loadView()
        self.view = OnboardingView(
            content: data,
            buttonTitle: Text.Onboarding.action,
            finalButtonTitle: Text.Onboarding.actionFinal,
            completedHandler: {
                print("completed")
            }
        )
    }
}
