//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysCollectionView: CollectionView {
    typealias Item = DaysCollectionCell
    enum Section {
        case sun
        case plan
    }
    typealias CellProvider = (UICollectionView, IndexPath, Item.Model) -> Item?
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item.Model>

    override var cellTypes: [UICollectionViewCell.Type] { [Item.self] }

    private(set) var diffableDataSource: DataSource?
    private var pageScrollDelegate: CollectionPageScrollDelegate?

    func configure(
        pageScrollHandler: @escaping CollectionPageScrollDelegate.ScrollToPageHandler,
        cellProvider: @escaping CellProvider
    ) {
        pageScrollDelegate = CollectionPageScrollDelegate(scrollToPageHandler: pageScrollHandler)
        delegate = pageScrollDelegate
        diffableDataSource = DataSource(collectionView: self, cellProvider: cellProvider)
        dataSource = diffableDataSource
    }

    func scrollToPage(_ page: Int, animated: Bool = true) {
        scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}
