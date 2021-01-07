//
//  DaysCollectionViewLayout.swift
//  Rise
//
//  Created by Владимир Королев on 05.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysCollectionViewLayout: UICollectionViewLayout {
    private let numberOfColumns = 3
    private let numberOfRows = 2
    private let cellPadding: CGFloat = 4

    private var cache: [[UICollectionViewLayoutAttributes]] = []

    private var displayedContentHeight: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }

    private var displayedContentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        CGSize(width: displayedContentWidth * CGFloat(numberOfColumns), height: displayedContentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let itemWidth = displayedContentWidth
        let itemHeight = displayedContentHeight / CGFloat(numberOfRows)

        var yOffsets: [CGFloat] = (0..<numberOfRows).map { CGFloat($0) * itemHeight }

        var currentColumn = 0
        var currentRow = 0

        for section in 0..<collectionView.numberOfSections {
            var sectionAttributes: [UICollectionViewLayoutAttributes] = []
            var xOffsets: [CGFloat] = (0..<numberOfColumns).map { CGFloat($0) * itemWidth }

            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let frame = CGRect(
                    x: xOffsets[currentColumn],
                    y: yOffsets[currentRow],
                    width: itemWidth,
                    height: itemHeight
                )
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                let attributes = UICollectionViewLayoutAttributes(
                    forCellWith: IndexPath(item: item, section: section)
                )
                attributes.frame = insetFrame
                sectionAttributes.append(attributes)
                xOffsets[currentColumn] += itemWidth
                currentColumn = currentColumn < (numberOfColumns - 1) ? (currentColumn + 1) : 0
            }
            yOffsets[currentRow] += itemHeight
            currentRow = currentRow < (numberOfRows - 1) ? (currentRow + 1) : 0
            cache.append(sectionAttributes)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for section in cache {
            for attributes in section {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cache[indexPath.section][indexPath.item]
    }
}
