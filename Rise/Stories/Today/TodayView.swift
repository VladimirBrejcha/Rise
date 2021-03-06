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
    @IBOutlet private var sleepButton: StandartButton!
    @IBOutlet private weak var timeUntilSleep: FloatingLabel!

    private var isConfigured = false

    func configure(
        timeUntilSleepDataSource: @escaping () -> FloatingLabel.Model,
        sleepHandler: @escaping () -> Void
    ) {
        if isConfigured { return }
        sleepButton.onTouchUp = { _ in sleepHandler() }
        timeUntilSleep.dataSource = timeUntilSleepDataSource
        timeUntilSleep.font = Styles.Label.Notification.font
        timeUntilSleep.beginRefreshing()
        isConfigured = true
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<DaysCollectionView.Section, DaysCollectionView.Item.Model>
    var snapshot: Snapshot { daysView.dataSource.snapshot() }

    func applySnapshot(_ snapshot: Snapshot) {
        daysView.dataSource.apply(snapshot)
    }
}
