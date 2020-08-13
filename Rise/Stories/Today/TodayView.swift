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
    
    var timeToSleepDataSource: (() -> FloatingLabel.Model)? {
        didSet {
            timeToSleepLabel.dataSource = timeToSleepDataSource
            timeToSleepDataSource == nil
                ? timeToSleepLabel.stopRefreshing()
                : timeToSleepLabel.beginRefreshing()
        }
    }
    var daysCollectionView: DaysCollectionView { daysView.collectionView }
    var sleepTouchUpHandler: (() -> Void)?
    var descriptionText: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }

    @IBAction private func sleepTouchUp(_ sender: Button) {
        sleepTouchUpHandler?()
    }
}
