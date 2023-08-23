//
//  ScheduleCreatedCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import DomainLayer

final class ScheduleCreatedCreateScheduleViewController: UIViewController {

    @IBOutlet private var icon: UIImageView!

    var requestNotificationPermissions: RequestNotificationPermissions! // DI

    override func viewDidLoad() {
        super.viewDidLoad()
        icon.layer.applyStyle(.gloomingIcon)
        Task {
            await requestNotificationPermissions(askExplicitlyFrom: self)
        }
    }
}
