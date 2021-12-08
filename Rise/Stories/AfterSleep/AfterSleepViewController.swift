//  
//  AfterSleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AfterSleepViewController: UIViewController {

    private var loadedView: AfterSleepView {
        view as! AfterSleepView
    }

    private let manageActiveSleep: ManageActiveSleep
    private let wentSleepTime: Date
    private let totalSleepTime: Schedule.Minute
    private let currentTime: Date = Date()

    // MARK: - LifeCycle

    init(manageActiveSleep: ManageActiveSleep) {
        self.manageActiveSleep = manageActiveSleep
        self.wentSleepTime = manageActiveSleep.sleepStartedAt ?? Date()
        self.totalSleepTime = Int(currentTime.timeIntervalSince(wentSleepTime)) / 60
        super.init(nibName: nil, bundle: nil)
        manageActiveSleep.endSleep()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = AfterSleepView(
            doneHandler: { [weak self] in
                self?.navigationController?.popToRootViewController(
                    animated: true
                )
            },
            appearance: .sleepFinished,
            wentSleepTime: wentSleepTime.HHmmString,
            wokeUpTime: currentTime.HHmmString,
            totalSleepTime: totalSleepTime > 0 ? totalSleepTime.HHmmString : nil
        )
    }
}
