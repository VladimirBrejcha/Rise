//
//  Int+Utils.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

extension Int {
    func toSeconds() -> Double {
        Double(self * 60)
    }

    var HHmmString: String {
        let hours = self / 60
        let minutes = self % 60

        return minutes == 0
            ? "\(hours) hours"
            : hours == 0
                ? "\(minutes) minutes"
                : "\(hours)h \(minutes)m"
    }
}
