//
//  CollectionViewWithSegmentedControl.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionViewWithSegmentedControl: DesignableContainerView, SegmentedControlViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var segmentedControl: SegmentedControlView!
    @IBOutlet weak var collectionView: TodayCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width  = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage > 2 || currentPage < 0 { return }
        segmentedControl.selectButton(SegmentedControlViewButtons(rawValue: currentPage)!)
    }
    
    // MARK: SegmentedControlViewDelegate
    func userDidSelect(segment: SegmentedControlViewButtons) {
        collectionView?.scrollToItem(at: IndexPath(item: segment.row, section: 0), at: .centeredHorizontally, animated: true)
    }
    
}
