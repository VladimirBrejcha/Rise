//
//  OnboardingViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

extension Onboarding {

  final class Controller: UIViewController, ViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
      .lightContent
    }

    enum OutCommand {
      case finish
    }
    typealias Deps = HasSetOnboardingCompleted
    typealias Params = [View.ContentView.Model]
    typealias View = Onboarding.View

    private let deps: Deps
    private let data: Params
    private let out: Out

    init(deps: Deps, params: Params, out: @escaping Out) {
      self.deps = deps
      self.data = params
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
        content: data,
        buttonTitle: Text.Onboarding.action,
        finalButtonTitle: Text.Onboarding.actionFinal,
        completedHandler: { [weak self] in
          self?.deps.setOnboardingCompleted(true)
          self?.out(.finish)
        }
      )
    }
  }
}
