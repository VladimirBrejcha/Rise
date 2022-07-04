//  
//  KeepAppOpenedSuggestionViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

extension KeepAppOpenedSuggestion {

  final class Controller: UIViewController, ViewController {

    enum OutCommand {
      case finish((() -> Void)?)
    }

    typealias View = KeepAppOpenedSuggestion.View
    typealias Params = (() -> Void)?

    private let out: Out
    private let completion: (() -> Void)?

    // MARK: - LifeCycle

    init(params: Params, out: @escaping Out) {
      self.completion = params
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
        continueHandler: { [unowned self] in
          out(.finish(completion))
        }
      )
    }
  }
}
