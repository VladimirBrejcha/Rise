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
    private let yesterdaySchedule: Schedule?
    private let todaySchedule: Schedule?
    private let wentSleepTime: Date
    private let totalSleepTime: Schedule.Minute
    private let currentTime: Date = Date()

    // MARK: - LifeCycle

    init(
        manageActiveSleep: ManageActiveSleep,
        getSchedule: GetSchedule
    ) {
        self.manageActiveSleep = manageActiveSleep
        self.todaySchedule = getSchedule.today()
        self.yesterdaySchedule = getSchedule.yesterday()
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
            adjustScheduleHandler: { [weak self] in
                if let self = self,
                   let schedule = self.todaySchedule
                {
                    self.present(
                        Story.adjustSchedule(
                            currentSchedule: schedule
                        )(),
                        with: .fullScreen
                    )
                }
            },
            appearance: .sleepFinished,
            descriptionText: makeDescriptionText(
                wentSleepTime: wentSleepTime.HHmmString,
                lateBy: {
                    guard let schedule = yesterdaySchedule else {
                        return nil
                    }
                    let minutes = minutes(
                        sinceScheduled: schedule,
                        wentSleepAt: wentSleepTime
                    )
                    return minutes > 0 ? minutes.HHmmString : nil
                }(),
                wokeUpTime: currentTime.HHmmString,
                totalSleepTime: totalSleepTime > 0 ? totalSleepTime.HHmmString : nil
            ),
            showAdjustSchedule: shouldAdjustSchedule(
                schedule: yesterdaySchedule,
                wentSleepTime: wentSleepTime
            )
        )
    }

    private func makeDescriptionText(
        wentSleepTime: String,
        lateBy: String?,
        wokeUpTime: String,
        totalSleepTime: String?
    ) -> String {
        var string = "You went to bed at \(wentSleepTime)"
        if let lateBy = lateBy {
            string.append(contentsOf: "\nit's \(lateBy) later than scheduled")
        }
        string.append(contentsOf: "\n\nYou woke up at \(wokeUpTime)")
        if let totalSleepTime = totalSleepTime {
            string.append(contentsOf: "\nwhich is a total of \(totalSleepTime) of sleep")
        }
        return string
    }

    private func shouldAdjustSchedule(
        schedule: Schedule?,
        wentSleepTime: Date
    ) -> Bool {
        guard let schedule = schedule else {
            return false
        }
        return !(-20...20)
            .contains(
                minutes(sinceScheduled: schedule, wentSleepAt: wentSleepTime)
            )
    }

    private func minutes(sinceScheduled: Schedule, wentSleepAt: Date) -> Int {
        calendar.dateComponents(
            [.minute],
            from: sinceScheduled.toBed.changeDayStoringTime(to: wentSleepAt),
            to: wentSleepAt
        ).minute ?? 0
    }
}
