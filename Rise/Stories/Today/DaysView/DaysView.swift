//
//  DaysView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

final class DaysView: UIView, SelectableStackViewDelegate, NibLoadable {
    typealias Snapshot = NSDiffableDataSourceSnapshot<DaysCollectionView.Section, DaysCollectionView.Item.Model>

    @IBOutlet private weak var segmentedControl: SelectableStackView!
    @IBOutlet private weak var collectionView: DaysCollectionView!
    var snapshot: Snapshot? { collectionView.diffableDataSource?.snapshot() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }

    func configure(cellProvider: @escaping DaysCollectionView.CellProvider) {
        collectionView.configure(
            pageScrollHandler: { [weak self] page in
                if page >= 0 && page <= 2 {
                    self?.segmentedControl.select(true, at: page)
                }
            },
            cellProvider: cellProvider
        )
        segmentedControl.delegate = self
    }

    func centerItems() {
        collectionView.scrollToPage(1, animated: false)
        segmentedControl.select(true, at: 1)
    }

    func applySnapshot(_ snapshot: Snapshot) {
        collectionView.diffableDataSource?.apply(snapshot)
    }

    // MARK: - SelectableStackViewDelegate -
    func didSelect(_ select: Bool, at index: Index, on selectableStackView: SelectableStackView) {
        if select {
            collectionView.scrollToPage(index)
        }
    }
}
