//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Vladimir Korolev on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

extension DaysCollectionView {
    typealias Section = NoonedDay
    typealias Item = DaysCollectionCell
    typealias CellProvider = (UICollectionView, IndexPath, Item.Model) -> Item?
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item.Model>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item.Model>
}

final class DaysCollectionView: CollectionView {

    override var cellTypes: [UICollectionViewCell.Type] { [Item.self] }
    private var diffableDataSource: DataSource?
    private var pageScrollDelegate: CollectionPageScrollDelegate?

    var snapshot: Snapshot? { diffableDataSource?.snapshot() }

    // MARK: - LifeCycle
    
    init(
        pageScrollHandler: @escaping CollectionPageScrollDelegate.ScrollToPageHandler,
        cellProvider: @escaping CellProvider
    ) {
        super.init(frame: .zero, collectionViewLayout: Self.createCollectionViewLayout)
        pageScrollDelegate = CollectionPageScrollDelegate(scrollToPageHandler: pageScrollHandler)
        delegate = pageScrollDelegate
        diffableDataSource = DataSource(collectionView: self, cellProvider: cellProvider)
        dataSource = diffableDataSource
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - Actions

    func applySnapshot(_ snapshot: Snapshot) {
        diffableDataSource?.apply(snapshot)
    }

    func scrollToPage(_ page: Int, animated: Bool = true) {
        scrollToItem(
            at: IndexPath(
                item: 0,
                section: page
            ),
            at: .centeredHorizontally,
            animated: animated
        )
    }

    // MARK: - Layout

    private static var createCollectionViewLayout: UICollectionViewLayout = {

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = .init(
            top: 4,
            leading: 4,
            bottom: 4,
            trailing: 4
        )

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal

        return UICollectionViewCompositionalLayout(
            section: .init(
                group: .vertical(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalHeight(1)
                    ),
                    subitem: item,
                    count: 2
                )
            ),
            configuration: configuration
        )
    }()
}