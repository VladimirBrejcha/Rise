//
//  Storyboard.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Storyboard {
    case main
    case plan
    case settings
    case popUp
    
    func get() -> UIStoryboard {
        switch self {
        case .main:
            return UIStoryboard(name: "Main", bundle: nil)
        case .plan:
            return UIStoryboard(name: "Plan", bundle: nil)
        case .settings:
            return UIStoryboard(name: "Settings", bundle: nil)
        case .popUp:
            return UIStoryboard(name: "ConfirmationPopUp", bundle: nil)
        }
    }
}
