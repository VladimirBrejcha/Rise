//
//  SegmentedControlView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum DaysSegmentedControlViewButtonDay: Int {
    case yesterday = 0
    case today = 1
    case tomorrow = 2
}

protocol DaysSegmentedControlViewDelegate: AnyObject {
    func didSelect(segment: DaysSegmentedControlViewButtonDay)
}

final class DaysSegmentedControlView: UIStackView {
    weak var delegate: DaysSegmentedControlViewDelegate?
    
    @IBOutlet private var buttons: [DaysSegmentedControlButton]!
    
    @IBAction private func buttonTouchUp(_ sender: DaysSegmentedControlButton) {
        selectButton(sender.day)
        delegate?.didSelect(segment: sender.day)
    }
    
    func selectButton(_ selectedButton: DaysSegmentedControlViewButtonDay) {
        for button in buttons {
            UIView.transition(with: button,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { button.isSelected = button.day == selectedButton ? true : false })
        }
    }
}
