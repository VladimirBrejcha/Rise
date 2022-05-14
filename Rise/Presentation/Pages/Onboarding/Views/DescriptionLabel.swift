//
//  DescriptionLabel.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension Onboarding.View.ContentView {
  
  final class DescriptionLabel: UIView {
    
    // MARK: - Subviews
    
    private let pointSide: CGFloat = 10
    
    private lazy var label: UILabel = {
      let label = UILabel()
      label.applyStyle(.mediumSizedBody)
      label.layer.applyStyle(
        .init(shadow: .whiteBgSeparatorBig)
      )
      label.numberOfLines = 0
      return label
    }()
    
    private lazy var point: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.layer.applyStyle(
        .init(
          shadow: .usual,
          cornerRadius: pointSide / 2
        )
      )
      return view
    }()
    
    // MARK: LifeCycle
    
    convenience init(text: String) {
      self.init(frame: .zero)
      self.label.text = text
      setup()
    }
    
    private func setup() {
      setupViews()
      setupLayout()
    }
    
    private func setupViews() {
      addSubviews(
        label,
        point
      )
    }   
    
    // MARK: - Layout
    
    private func setupLayout() {
      point.activateConstraints(
        point.heightAnchor.constraint(equalToConstant: pointSide),
        point.widthAnchor.constraint(equalToConstant: pointSide),
        point.leadingAnchor.constraint(equalTo: leadingAnchor),
        point.centerYAnchor.constraint(equalTo: label.centerYAnchor)
      )
      label.activateConstraints(
        label.leadingAnchor.constraint(equalTo: point.trailingAnchor, constant: 16),
        label.topAnchor.constraint(equalTo: topAnchor),
        label.bottomAnchor.constraint(equalTo: bottomAnchor),
        label.trailingAnchor.constraint(equalTo: trailingAnchor)
      )
    }
  }
}
