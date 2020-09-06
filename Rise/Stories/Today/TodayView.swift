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
    
    // MARK: - Handlers & DataSource
    struct Handlers {
        let sleepHandler: () -> Void
    }
    var handlers: Handlers?
    
    @IBAction private func sleepTouchUp(_ sender: Button) {
        handlers?.sleepHandler()
    }
    
    struct DataSource {
        let collection: UICollectionViewDataSource
        let timeUntilSleep: () -> FloatingLabel.Model
    }
    
    // MARK: - Configure
    private var isConfigured = false
    func configure(dataSource: DataSource, handlers: Handlers) {
        if isConfigured { return }
        
        self.handlers = handlers
        daysView.collectionView.dataSource = dataSource.collection
        timeToSleepLabel.dataSource = dataSource.timeUntilSleep
        timeToSleepLabel.beginRefreshing()
        
        isConfigured = true
    }
    
    func reloadItems(at indexes: [Int]) {
        daysView.collectionView.reloadItems(at: indexes.map { IndexPath(item: $0, section: 0) })
    }
    
    func getIndexOf(cell: DaysCollectionCell) -> Int? {
        daysView.collectionView.indexPath(for: cell)?.row
    }
}
