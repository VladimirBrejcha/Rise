//
//  SettingsViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol SettingsViewInput: AnyObject {
    
}

protocol SettingsViewOutput: AnyObject {
    
}

final class SettingsViewController: UIViewController, SettingsViewInput {
    var output: SettingsViewOutput!
}
