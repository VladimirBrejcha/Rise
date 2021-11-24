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

    private let preventAppSleep: PreventAppSleep
    private let changeScreenBrightness: ChangeScreenBrightness
    private var alarmTime: Date

    private var editingAlarmTime: Date?
    private var lowerBrightnessDispatchItem: DispatchWorkItem?

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

    init(
        alarmTime: Date,
        preventAppSleep: PreventAppSleep,
        changeSleepBrightness: ChangeScreenBrightness
    ) {
        self.alarmTime = alarmTime
        self.preventAppSleep = preventAppSleep
        self.changeScreenBrightness = changeSleepBrightness
        super.init(nibName: nil, bundle: nil)
        preventAppSleep(true)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        preventAppSleep(false)
        lowerBrightnessDispatchItem?.cancel()
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
                self?.restoreBrightness()
                self?.dismiss(animated: true)
            },
            keepAppOpenedHandler: { [weak self] in
                self?.present(
                    Story.keepAppOpenedSuggestion(completion: nil)(),
                    with: .modal
                )
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginRefreshing()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        prepareToLowerBrightness(in: 20)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        lowerBrightnessDispatchItem?.cancel()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        restoreBrightness()
    }

    // MARK: - Internal

    private func prepareToLowerBrightness(in seconds: CGFloat) {
        let lowerBrightnessDispatchItem = DispatchWorkItem { [weak self] in
            self?.changeScreenBrightness(to: .low)
        }
        self.lowerBrightnessDispatchItem = lowerBrightnessDispatchItem

        DispatchQueue.main.asyncAfter(
            deadline: .now() + seconds,
            execute: lowerBrightnessDispatchItem
        )
    }

    private func restoreBrightness() {
        lowerBrightnessDispatchItem?.cancel()
        changeScreenBrightness(to: .userDefault)
        prepareToLowerBrightness(in: 7)
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
