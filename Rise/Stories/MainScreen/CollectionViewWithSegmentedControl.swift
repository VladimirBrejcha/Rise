//
//  CollectionViewWithSegmentedControl.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CollectionViewWithSegmentedControl: DesignableContainerView, SegmentedControlViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var segmentedControl: SegmentedControlView!
    @IBOutlet weak var collectionView: UICollectionView!
    private let cellIdentifier = "collectionViewWithSegmentedControlCellID"
    var timesArray: [SunModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.delegate = self
        collectionView.register(UINib(nibName: "TodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentedControl.buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TodayCollectionViewCell

        if timesArray.indices.contains(indexPath.row) {
            cell.sunriseTimeLabel.text = DatesConverter.formatDateToHHmm(date: timesArray[indexPath.row].sunrise)
            cell.sunsetTimeLabel.text = DatesConverter.formatDateToHHmm(date: timesArray[indexPath.row].sunset)
            cell.showContent()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
        let width  = collectionView.bounds.width
        return CGSize(width: width, height: height)
    }
    
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
