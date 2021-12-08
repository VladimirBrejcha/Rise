//
//  AlarmingViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AlarmingViewController: UIViewController {

    private var loadedView: AlarmingView { view as! AlarmingView }

    private let changeScreenBrightness: ChangeScreenBrightness

    // MARK: - LifeCycle

    init(changeScreenBrightness: ChangeScreenBrightness) {
        self.changeScreenBrightness = changeScreenBrightness
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

        self.view = AlarmingView(
            stopHandler: { [weak self] in
                self?.navigationController?.replaceAllOnTopOfRoot(
                    with: Story.afterSleep()
                )
            },
            snoozeHandler: { [weak self] in
                self?.navigationController?.replaceAllOnTopOfRoot(
                    with: Story.sleep(
                        alarmTime: Date().addingTimeInterval(minutes: 8)
                    )()
                )
            },
            currentTimeDataSource: {
                Date().HHmmString
            }
        )
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
