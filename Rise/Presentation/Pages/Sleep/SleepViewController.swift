//
//  SleepViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 23/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer
import UILibrary

final class SleepViewController:
    UIViewController,
    AutoRefreshable,
    ViewController
{
    enum OutCommand {
        case showKeepAppOpenedSuggestion
        case showAfterSleep
        case showAlarming
    }

    typealias Deps =
    HasManageActiveSleep
    & HasPreventAppSleep
    & HasChangeScreenBrightness
    & HasPlayWhileSleepingMelody
    & HasPlayBeforeAlarmMelody
    & HasScheduleSleepNotifications

    typealias Params = Date
    typealias View = SleepView

    private let deps: Deps
    private let out: Out
    private var alarmTime: Date

    private var editingAlarmTime: Date?
    private var lowerBrightnessDispatchItem: DispatchWorkItem?

    private let playWhileSleepingMelody: PlayMelody
    private let playBeforeAlarmMelody: PlayMelody

    private var whileSleepingPlayed = false

    private lazy var sleepLengthIsEnoughForMelodies: Bool = {
        let minsBeforeAlarm = calendar.dateComponents(
            [.minute], from: Date.now, to: alarmTime
        ).minute
        guard let minsBeforeAlarm, minsBeforeAlarm >= 60
        else { return false }
        return true
    }()

    // MARK: - AutoRefreshable

    var timer: Timer?
    var dataSource: (() -> Date)? = { Date.now }
    var refreshInterval: Double = 2

    func refresh(with data: Date) {

        if data >= alarmTime {
            stopRefreshing()
            playWhileSleepingMelody.stop()
            playBeforeAlarmMelody.stop()
            out(.showAlarming)
            return
        }

        guard sleepLengthIsEnoughForMelodies else { return }

        let minsBeforeAlarm = calendar.dateComponents(
            [.minute], from: data, to: alarmTime
        ).minute
        guard let minsBeforeAlarm else { return }

        if whileSleepingPlayed == false
            && minsBeforeAlarm > 30
            && playWhileSleepingMelody.isActive == false
        {
            whileSleepingPlayed = true
            playWhileSleepingMelody.play()
        }

        else if minsBeforeAlarm <= 30,
           playBeforeAlarmMelody.isActive == false
        {
            playWhileSleepingMelody.stop()
            playBeforeAlarmMelody.play()
        }
    }

    // MARK: - LifeCycle

    init(deps: Deps, params: Params, out: @escaping Out) {
        self.alarmTime = params
        self.deps = deps
        self.out = out
        self.playWhileSleepingMelody = deps.playWhileSleepingMelody
        self.playBeforeAlarmMelody = deps.playBeforeAlarmMelody
        super.init(nibName: nil, bundle: nil)
        deps.preventAppSleep(true)
        deps.manageActiveSleep.alarmAt = alarmTime
        deps.scheduleSleepNotifications.setAlarmNotification(time: alarmTime)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        deps.preventAppSleep(false)
        lowerBrightnessDispatchItem?.cancel()
    }

    override func loadView() {
        super.loadView()

        self.view = View(
            currentTimeDataSource: {
                Date().HHmmString
            },
            wakeUpInDataSource: { [weak self] in
                if let timeLeft = self?.alarmTime.fixIfNeeded().timeIntervalSince(Date.now).HHmmString {
                    return FloatingLabel.Model(text: "Wake up in \(timeLeft)", alpha: 1)
                } else {
                    return FloatingLabel.Model(text: "", alpha: 0)
                }
            },
            alarmTime: "Alarm at \(alarmTime.HHmmString)",
            stopHandler: { [weak self] in
                self?.restoreBrightness()
                self?.playWhileSleepingMelody.stop()
                self?.playBeforeAlarmMelody.stop()
                self?.deps.scheduleSleepNotifications.cancelAlarmNotification()
                self?.out(.showAfterSleep)
            },
            keepAppOpenedHandler: { [weak self] in
                self?.out(.showKeepAppOpenedSuggestion)
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        beginRefreshing()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareToLowerBrightness(in: 3)
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
            self?.deps.changeScreenBrightness(to: .low)
        }
        self.lowerBrightnessDispatchItem = lowerBrightnessDispatchItem

        DispatchQueue.main.asyncAfter(
            deadline: .now() + seconds,
            execute: lowerBrightnessDispatchItem
        )
    }

    private func restoreBrightness() {
        lowerBrightnessDispatchItem?.cancel()
        deps.changeScreenBrightness(to: .userDefault)
        prepareToLowerBrightness(in: 3)
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
