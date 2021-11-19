//
//  Storyboard.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

struct Storyboard {
    static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let createSchedule: UIStoryboard = UIStoryboard(name: "CreateSchedule", bundle: nil)
    static let confirmation: UIStoryboard = UIStoryboard(name: "Confirmation", bundle: nil)
    static let sleep: UIStoryboard = UIStoryboard(name: "Sleep", bundle: nil)
}

extension UIStoryboard {
    func instantiateViewController<Type: UIViewController>(of type: Type.Type) -> Type {
        instantiateViewController(withIdentifier: String(describing: type)) as! Type
    }
}
