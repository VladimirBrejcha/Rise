//
//  SegmentedControlButton.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class SegmentedControlButton: UIButton {
    var day = SegmentedControlViewButtons.today
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'day' instead.")
    @IBInspectable var buttonIndex: NSNumber? {
        willSet {
            if let newDay = SegmentedControlViewButtons(rawValue: Int(truncating: newValue ?? NSNumber(integerLiteral: 1))) {
                if newDay == day {
                    isSelected = true
                }
                day = newDay
            }
        }
    }
}
