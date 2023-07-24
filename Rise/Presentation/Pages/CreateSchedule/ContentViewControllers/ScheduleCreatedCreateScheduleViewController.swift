//
//  ScheduleCreatedCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScheduleCreatedCreateScheduleViewController: UIViewController {

    @IBOutlet private var icon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        icon.layer.applyStyle(.gloomingIcon)
    }
}
