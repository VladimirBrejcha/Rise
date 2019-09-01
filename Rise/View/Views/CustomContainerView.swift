//
//  CustomContainerView.swift
//  Rise
//
//  Created by Vladimir Korolev on 15/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
class CustomContainerView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
}

class CustomContainerViewWithTime: CustomContainerView {
    @IBOutlet weak var morningTimeLabel: UILabel!
    @IBOutlet weak var eveningTimeLabel: UILabel!
}

class CustomContainerViewWithSegmentedControl: CustomContainerView, CustomSegmentedControlDelegate {
    
    private var segmentedControl: CustomSegmentedControl!
    @IBOutlet weak var riseContainer: CustomContainerViewWithTime!
    @IBOutlet weak var wakeContainer: CustomContainerViewWithTime!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupSegmentedControl()
    }
    
    // MARK: UISetup Methods
    private func setupSegmentedControl() {
        segmentedControl = CustomSegmentedControl(buttonTitles: [SegmentedControlCases.yesterday.dayDescription,
                                                                 SegmentedControlCases.today.dayDescription,
                                                                 SegmentedControlCases.tomorrow.dayDescription], startingIndex: 1)
        segmentedControl.backgroundColor = .clear
        segmentedControl.delegate = self
        
        addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
    }
}

// MARK: CustomContainerViewWithSegmentedControl
extension CustomContainerViewWithSegmentedControl {
    func segmentedButtonPressed(_ segment: SegmentedControlCases) {
        switch segment {
        case .yesterday:
            riseContainer.morningTimeLabel.text = "07:00"
            riseContainer.eveningTimeLabel.text = "23:47"
            wakeContainer.morningTimeLabel.text = "07:00"
            wakeContainer.eveningTimeLabel.text = "23:00"
        case .today:
            riseContainer.morningTimeLabel.text = "06:54"
            riseContainer.eveningTimeLabel.text = "23:57"
            wakeContainer.morningTimeLabel.text = "06:54"
            wakeContainer.eveningTimeLabel.text = "23:05"
        case .tomorrow:
            riseContainer.morningTimeLabel.text = "06:49"
            riseContainer.eveningTimeLabel.text = "23:59"
            wakeContainer.morningTimeLabel.text = "06:49"
            wakeContainer.eveningTimeLabel.text = "23:10"
        }
    }
}
