//
//  TodayView.swift
//  Rise
//
//  Created by Владимир Королев on 01.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayView: UIView {
    @IBOutlet private weak var daysView: DaysView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeToSleepLabel: FloatingLabel!
    
    struct Model {
        let collectionViewDataSource: UICollectionViewDataSource
        let timeUntilSleepDataSource: (() -> FloatingLabel.Model)?
        let sleepHandler: () -> Void
    }
    var model: Model? {
        didSet {
            if let model = model {
                daysView.collectionView.dataSource = model.collectionViewDataSource
                timeToSleepLabel.dataSource = model.timeUntilSleepDataSource
                model.timeUntilSleepDataSource == nil
                    ? timeToSleepLabel.stopRefreshing()
                    : timeToSleepLabel.beginRefreshing()
            } else {
                timeToSleepLabel.stopRefreshing()
            }
        }
    }

    @IBAction private func sleepTouchUp(_ sender: Button) {
        model?.sleepHandler()
    }
    
    func reloadItem(at index: Int) {
        daysView.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func reloadItems(at indexes: [Int]) {
        daysView.collectionView.reloadItems(at: indexes.map { IndexPath(item: $0, section: 0) })
    }
    
    func reloadCollection() {
        daysView.collectionView.reloadData()
    }
    
    func getIndexOf(cell: DaysCollectionCell) -> Int? {
        daysView.collectionView.indexPath(for: cell)?.row
    }
}

extension TodayView.Model: Changeable {
    init(copy: ChangeableWrapper<TodayView.Model>) {
        self.init(
            collectionViewDataSource: copy.collectionViewDataSource,
            timeUntilSleepDataSource: copy.timeUntilSleepDataSource,
            sleepHandler: copy.sleepHandler
        )
    }
}
