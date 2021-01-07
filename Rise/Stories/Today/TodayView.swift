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

    typealias Snapshot = NSDiffableDataSourceSnapshot<DaysCollectionView.Section, DaysCollectionView.Item.Model>

    // MARK: - Handlers & DataSource
    var sleepHandler: (() -> Void)?
    var timeUntilSleepDataSource: (() -> FloatingLabel.Model)?

    // MARK: - Configure
    private var isConfigured = false
    func configure(
        timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
        sleepHandler: @escaping () -> Void
    ) {
        if isConfigured { return }
        self.sleepHandler = sleepHandler
        timeToSleepLabel.dataSource = timeUntilSleepDataSource
        timeToSleepLabel.beginRefreshing()
        isConfigured = true
    }

    var snapshot: Snapshot { daysView.dataSource.snapshot() }
    func applySnapshot(_ snapshot: Snapshot) {
        daysView.dataSource.apply(snapshot)
    }

    @IBAction private func sleepTouchUp(_ sender: Button) {
        sleepHandler?()
    }
}
