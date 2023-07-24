//
//  EditScheduleSegmentedControlCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

extension EditSchedule.TableView {

  final class SegmentedControlCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
  {
    static var height: CGFloat { 70 }

    // MARK: - Subviews

    private lazy var container: DesignableContainerView = {
      let container = DesignableContainerView()
      return container
    }()

    private lazy var segmentedControl: UISegmentedControl = {
      let segmentedControl = UISegmentedControl()
      return segmentedControl
    }()

    private lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.applyStyle(.mediumSizedBody)
      return label
    }()

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
      setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
      contentView.backgroundColor = .clear
      backgroundColor = .clear
      contentView.addSubviews(
        titleLabel,
        container.addSubviews(
          segmentedControl
        )
      )
    }

    // MARK: - Layout

    private func setupLayout() {
      titleLabel.activateConstraints(
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
      )
      container.activateConstraints(
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
      )
      segmentedControl.activateConstraints(
        segmentedControl.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        segmentedControl.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        segmentedControl.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        segmentedControl.topAnchor.constraint(equalTo: container.topAnchor)
      )
    }

    // MARK: - ConfigurableCell

    func configure(with model: Model) {
      titleLabel.text = model.title
      segmentedControl.removeAllSegments()
      model.segments.enumerated().forEach {
        segmentedControl.insertSegment(action: $1, at: $0, animated: false)
      }
      segmentedControl.selectedSegmentIndex = model.selectedSegment
    }
  }
}
