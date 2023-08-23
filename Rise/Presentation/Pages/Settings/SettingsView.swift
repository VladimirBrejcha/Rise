//
//  SettingsView.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension Settings {

  final class View: UIView {

    private let selectionHandler: (Settings.Setting) -> Void

    // MARK: - Subviews

    private lazy var VStack: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.alignment = .trailing
      stack.clipsToBounds = true
      stack.layer.applyStyle(.usualBorder)
      stack.backgroundColor = .white.withAlphaComponent(0.05)
      return stack
    }()

    // MARK: - LifeCycle

    init(selectionHandler: @escaping (Settings.Setting) -> Void) {
      self.selectionHandler = selectionHandler
      super.init(frame: .zero)
      setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("This class does not support NSCoder")
    }

    private func setup() {
      setupViews()
      setupLayout()
    }

    private func setupViews() {
      addSubviews(
        VStack
      )
    }

    func reconfigure(with models: [ItemView.Model]) {
      VStack.arrangedSubviews.forEach {
        $0.removeFromSuperview()
      }
      VStack.addArrangedSubviews(
        models.map { model in
          ItemView(
            model: model,
            touchHandler: { [weak self] in
              self?.selectionHandler(model.setting)
            }
          )
        },
        separated: true
      )
      VStack.arrangedSubviews.forEach { view in
          view.activateConstraints {
              [$0.widthAnchor.constraint(
                equalTo: VStack.widthAnchor,
                constant: view is ItemView ? 0 : -44
              )]
          }
      }
    }

    func deselectAll() {
      VStack.arrangedSubviews.forEach { view in
        if let view = view as? ItemView {
          view.drawSelection(false)
        }
      }
    }

    // MARK: - Layout

    private func setupLayout() {
        VStack.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            $0.centerYAnchor.constraint(equalTo: centerYAnchor)]
        }
    }
  }
}
