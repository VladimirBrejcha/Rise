//
//  DaysView.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

extension Days {

  final class View: UIView, SelectableStackViewDelegate {

    var snapshot: CollectionView.Snapshot? { daysCollection.snapshot }
    private let cellProvider: CollectionView.CellProvider
    private let sectionTitles: [String]

    // MARK: - Subviews

    private lazy var segmentedControl: SelectableStackView = {
      let view = SelectableStackView()
      view.axis = .horizontal
      view.distribution = .fillEqually
      view.delegate = self
      return view
    }()

    private lazy var daysCollection: CollectionView = {
      let collection = CollectionView(
        pageScrollHandler: { [weak self] page in
          if page >= 0 && page <= 2 {
            self?.segmentedControl.select(true, at: page)
          }
        },
        cellProvider: cellProvider
      )
      collection.backgroundColor = .clear
      collection.showsHorizontalScrollIndicator = false
      collection.isPagingEnabled = true
      collection.layer.cornerRadius = 12
      return collection
    }()

    // MARK: - LifeCycle

    init(cellProvider: @escaping CollectionView.CellProvider, sectionTitles: [String]) {
      self.cellProvider = cellProvider
      self.sectionTitles = sectionTitles
      super.init(frame: .zero)
      setupViews()
      setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
      addSubviews(
        segmentedControl.addArrangedSubviews(
          sectionTitles.map(SelectableStackViewButton.init(title:))
        ),
        daysCollection
      )
    }

    private func setupLayout() {
      segmentedControl.activateConstraints(
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        segmentedControl.heightAnchor.constraint(equalToConstant: 20),
        segmentedControl.topAnchor.constraint(equalTo: topAnchor)
      )
      daysCollection.activateConstraints(
        daysCollection.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 4),
        daysCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
        daysCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
        daysCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
      )
    }

    // MARK: - Actions

    func centerItems() {
      daysCollection.scrollToPage(1, animated: false)
      segmentedControl.select(true, at: 1)
    }

    func applySnapshot(_ snapshot: CollectionView.Snapshot) {
      daysCollection.applySnapshot(snapshot)
    }

    // MARK: - SelectableStackViewDelegate

    func didSelect(_ select: Bool, at index: Index, on selectableStackView: SelectableStackView) {
      if select {
        daysCollection.scrollToPage(index)
      }
    }
  }
}
