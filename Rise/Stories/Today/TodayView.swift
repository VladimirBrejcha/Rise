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
    
    struct DataSource {
        let collection: UICollectionViewDataSource
        let timeUntilSleep: () -> FloatingLabel.Model
    }
    
    struct Handlers {
        let sleepHandler: () -> Void
    }
    var handlers: Handlers?
    
    func configure(dataSource: DataSource, handlers: Handlers) {
        self.handlers = handlers
        daysView.collectionView.dataSource = dataSource.collection
        timeToSleepLabel.dataSource = dataSource.timeUntilSleep
        timeToSleepLabel.beginRefreshing()
    }

    @IBAction private func sleepTouchUp(_ sender: Button) {
        handlers?.sleepHandler()
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
