//
//  DaysSegmentedControlViewButton.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysSegmentedControlButton: UIButton {
    var day = DaysSegmentedControlViewButtonDay.today
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'day' instead.")
    @IBInspectable var buttonIndex: NSNumber? {
        willSet {
            if let newDay = DaysSegmentedControlViewButtonDay(rawValue: Int(truncating: newValue ?? NSNumber(integerLiteral: 1))) {
                if newDay == day {
                    isSelected = true
                }
                day = newDay
            }
        }
    }
}
