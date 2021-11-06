//
//  Double+Utils.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

extension Double {
    func toMinutes() -> Int {
        Int(self / 60)
    }

    var HHmmString: String {
        toMinutes().HHmmString
    }
}
