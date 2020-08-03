//
//  DaysView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

final class DaysView:
    DesignableContainerView,
    UICollectionViewDelegateFlowLayout,
    SelectableStackViewDelegate
{
    @IBOutlet private weak var segmentedControl: SelectableStackView!
    @IBOutlet weak var collectionView: DaysCollectionView!
    
    private var shouldCenter = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        segmentedControl.delegate = self
        segmentedControl.select(true, at: 1)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if shouldCenter {
            collectionView.scrollToItem(
                at: IndexPath(item: 2, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
            shouldCenter = false
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width,
               height: (collectionView.bounds.height / 2) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
    
    // MARK: - UIScrollViewDelegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if !(currentPage > 2 || currentPage < 0) {
            segmentedControl.select(true, at: currentPage)
        }
    }
    
    // MARK: - SelectableStackViewDelegate -
    func didSelect(
        _ select: Bool,
        at index: Index,
        on selectableStackView: SelectableStackView
    ) {
        if select {
            let item = index * 2
            self.collectionView?.scrollToItem(
                at: IndexPath(item: item, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
}
