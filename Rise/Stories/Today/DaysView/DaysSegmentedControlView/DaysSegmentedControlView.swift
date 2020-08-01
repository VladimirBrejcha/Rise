//
//  SegmentedControlView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

enum DaysSegmentedControlViewButtonDay: Int {
    case yesterday = 0
    case today = 1
    case tomorrow = 2
}

final class DaysSegmentedControlView: UIStackView {
    var onSegmentTouch: ((DaysSegmentedControlViewButtonDay) -> Void)?
    
    @IBOutlet private var buttons: [DaysSegmentedControlButton]!
    
    @IBAction private func buttonTouchUp(_ sender: DaysSegmentedControlButton) {
        selectButton(sender.day)
        onSegmentTouch?(sender.day)
    }
    
    func selectButton(_ selectedButton: DaysSegmentedControlViewButtonDay) {
        for button in buttons {
            UIView.transition(
                with: button,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: { button.isSelected = button.day == selectedButton ? true : false }
            )
        }
    }
}
