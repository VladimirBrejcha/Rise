//
//  SegmentedControlView.swift
//  Rise
//
//  Created by Владимир Королев on 08/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum SegmentedControlViewButtons: Int {
    
    case yesterday = 0
    case today = 1
    case tomorrow = 2
    
    var dayDescription: String {
        switch self.rawValue {
        case 0:
            return "yesterday"
        case 1:
            return "today"
        case 2:
            return "tomorrow"
        default:
            return "wrong case"
        }
    }
    
    var row: Int {
        return self.rawValue
    }
}

protocol SegmentedControlViewDelegate: AnyObject {
    func userDidSelect(segment: SegmentedControlViewButtons)
}

class SegmentedControlView: UIStackView {
    weak var delegate: SegmentedControlViewDelegate?
    
    @IBOutlet var buttons: [SegmentedControlButton]!
    private var selectedButton = SegmentedControlViewButtons.today
    
    func selectButton(_ selectedButton: SegmentedControlViewButtons) {
        for button in buttons {
            UIView.transition(with: button,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { button.isSelected = button.day == selectedButton ? true : false },
                              completion: nil)
            self.selectedButton = selectedButton
        }
    }
    
    @IBAction func didPressButton(_ sender: SegmentedControlButton) {
        selectButton(sender.day)
        delegate?.userDidSelect(segment: sender.day)
    }
}
