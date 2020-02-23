//
//  DaysView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysView:
    DesignableContainerView,
    UICollectionViewDelegateFlowLayout
{
    @IBOutlet private weak var segmentedControl: DaysSegmentedControlView!
    @IBOutlet weak var collectionView: DaysCollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        
        segmentedControl.onSegmentTouch = { segment in
            let item = segment.rawValue * 2
            self.collectionView?.scrollToItem(
                at: IndexPath(item: item, section: 0),
                at: .centeredHorizontally,
                animated: true
            )
        }
    }
    
    private var shouldCenter = true
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    // MARK: - UIScrollViewDelegate -
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        if !(currentPage > 2 || currentPage < 0) {
            segmentedControl.selectButton(DaysSegmentedControlViewButtonDay(rawValue: currentPage)!)
        }
    }
}
