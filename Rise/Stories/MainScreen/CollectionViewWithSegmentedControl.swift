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
    @IBOutlet weak var collectionView: UICollectionView!
    private let cellIdentifier = "collectionViewWithSegmentedControlCellID"
    
    var cellModels: [TodayCellModel] {
        get { return dataSource.models }
        set { dataSource.models = newValue }
    }
    
    private var dataSource: CollectionViewDataSource<TodayCellModel>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.delegate = self
        collectionView.register(UINib(nibName: "TodayCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        dataSource = CollectionViewDataSource.make(for: [buildLoadingCellModel(), buildLoadingCellModel(), buildLoadingCellModel()],
                                                   reuseIdentifier: cellIdentifier)
        collectionView.dataSource = dataSource
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func updateView(with sunModelArray: [SunModel]) {
        var models: [TodayCellModel] = []
        sunModelArray.forEach { sunModel in models.append(buildCellModel(from: sunModel)) }
        cellModels = models
        collectionView.reloadData()
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
    
    private func buildCellModel(from sunModel: SunModel) -> TodayCellModel {
        return TodayCellModel(isDataLoaded: true, sunriseTime: DatesConverter.formatDateToHHmm(date: sunModel.sunrise),
                              sunsetTime: DatesConverter.formatDateToHHmm(date: sunModel.sunset))
    }
    
    private func buildLoadingCellModel() -> TodayCellModel {
        return TodayCellModel(isDataLoaded: false, sunriseTime: "", sunsetTime: "")
    }
}

extension CollectionViewDataSource where Model == TodayCellModel {
    static func make(for cellModels: [TodayCellModel],
                     reuseIdentifier: String = "collectionViewWithSegmentedControlCellID") -> CollectionViewDataSource {
        return CollectionViewDataSource (models: cellModels, reuseIdentifier: reuseIdentifier) { (model, cell) in
            (cell as! TodayCollectionViewCell).cellModel = model
        }
    }
}
