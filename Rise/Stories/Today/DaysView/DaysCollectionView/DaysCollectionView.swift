//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 14.10.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysCollectionView: CollectionView, UICollectionViewDelegate {
    typealias Cell = DaysCollectionCell
    override var cellTypes: [UICollectionViewCell.Type] { [Cell.self] }

    enum Section {
        case sun
        case plan
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Cell.Model>
    private(set) var diffableDataSource: DataSource! // lateinit

    var didScrollToPageHandler: ((_ page: Int) -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    private func sharedInit() {
        self.delegate = self
        diffableDataSource = DataSource(
            collectionView: self,
            cellProvider: { collection, indexPath, item -> UICollectionViewCell? in
                if let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: String(describing: Cell.self),
                    for: indexPath
                ) as? DaysCollectionCell {
                    cell.configure(with: item)
                    return cell
                }
                return nil
            }
        )
    }

    // MARK: - UICollectionViewDelegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        didScrollToPageHandler?(currentPage)
    }
}
