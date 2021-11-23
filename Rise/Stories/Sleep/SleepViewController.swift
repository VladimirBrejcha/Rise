//
//  SleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SleepViewController: UIViewController, AutoRefreshable {

    private var loadedView: SleepView { view as! SleepView }
    
    private var alarmTime: Date
    private var editingAlarmTime: Date?

    // MARK: - AutoRefreshable

    var timer: Timer?
    var dataSource: (() -> Date)? = { Date() }
    var refreshInterval: Double = 2

    func refresh(with data: Date) {
        // Check if it is time to alarm
//        if data >= alarmTime {
//            stopRefreshing()
//            self.navigationController?.setViewControllers([Story.alarming(alarmTime: alarmTime)()], animated: true)
//        }
    }

    // MARK: - LifeCycle

    init(alarmTime: Date) {
        self.alarmTime = alarmTime
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view = SleepView(
            currentTimeDataSource: {
                Date().HHmmString
            },
            wakeUpInDataSource: { [weak self] in
                if let timeLeft = self?.alarmTime.fixIfNeeded().timeIntervalSince(Date()).HHmmString {
                    return FloatingLabel.Model(text: "Wake up in \(timeLeft)", alpha: 1)
                } else {
                    return FloatingLabel.Model(text: "", alpha: 0)
                }
            },
            alarmTime: "Alarm at \(alarmTime.HHmmString)",
            stopHandler: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginRefreshing()
    }    
}

fileprivate extension Date {
    func fixIfNeeded() -> Date {
        if self < Date() {
            return self.changeDayStoringTime(to: .tomorrow)
        } else {
            return self
        }
    }
}
