//
//  AlarmingViewController.swift
//  Rise
//
//  Created by Владимир Королев on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AlarmingViewController: UIViewController {
    @IBOutlet private var alarmingView: AlarmingView!

    var alarmTime: Date! // DI
    
    private let audioPlayer = AudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        alarmingView.configure(
            timeDataSource: { Date().HHmmString },
            didSnooze: { [weak self] in
                guard let self = self else { return }
                self.navigationController!.setViewControllers(
                    [Story.sleep(alarmTime: self.alarmTime.addingTimeInterval(minutes: 10))()],
                    animated: true
                )
            },
            didStop: { [weak self] in
                self?.dismiss(animated: true)
            }
        )
    }
}
