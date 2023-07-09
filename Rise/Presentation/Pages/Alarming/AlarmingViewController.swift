//
//  AlarmingViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer

final class AlarmingViewController: UIViewController, ViewController {
    
    enum OutCommand {
        case alarmStopped
        case alarmSnoozed(newAlarmTime: Date)
    }
    
    typealias Deps = HasChangeScreenBrightness & HasPlayAlarmMelody
    typealias View = AlarmingView
    
    private let changeScreenBrightness: ChangeScreenBrightness
    private let playAlarmMelody: PlayAlarmMelody
    private let out: Out
    
    // MARK: - LifeCycle
    
    init(deps: Deps, out: @escaping Out) {
        self.changeScreenBrightness = deps.changeScreenBrightness
        self.out = out
        self.playAlarmMelody = deps.playAlarmMelody
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        changeScreenBrightness(to: .userDefault)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view = View(
            stopHandler: { [weak self] in self?.out(.alarmStopped)
                self?.playAlarmMelody.stop()
            },
            snoozeHandler: { [weak self] in
                self?.playAlarmMelody.stop()
                self?.out(.alarmSnoozed(
                    newAlarmTime: Date().addingTimeInterval(minutes: 8))
                )
            },
            currentTimeDataSource: { Date().HHmmString }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        playAlarmMelody.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeScreenBrightness(to: .high)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeScreenBrightness(to: .userDefault)
    }
}
