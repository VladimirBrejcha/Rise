//
//  DaysCollectionView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysView: DesignableContainerView, DaysSegmentedControlViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var segmentedControl: DaysSegmentedControlView!
    @IBOutlet weak var collectionView: DaysCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        segmentedControl.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width  = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
    
    // MARK: - UIScrollViewDelegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if currentPage > 2 || currentPage < 0 { return }
        
        segmentedControl.selectButton(DaysSegmentedControlViewButtonDay(rawValue: currentPage)!)
    }
    
    // MARK: - DaysSegmentedControlViewDelegate -
    func didSelect(segment: DaysSegmentedControlViewButtonDay) {
        collectionView?.scrollToItem(at: IndexPath(item: segment.rawValue, section: 0), at: .centeredHorizontally, animated: true)
    }
}
