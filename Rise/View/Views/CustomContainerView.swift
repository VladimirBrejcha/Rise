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

class CustomContainerViewWithSegmentedControl: CustomContainerView {
    
    private var segmentedControl: CustomSegmentedContrl!
    @IBOutlet weak var riseContainer: CustomContainerViewWithTime!
    @IBOutlet weak var wakeContainer: CustomContainerViewWithTime!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupSegmentedControl()
    }
    
    // MARK: UISetup Methods
    private func setupSegmentedControl() {
        
        segmentedControl = CustomSegmentedContrl(buttonTitles: "yesterday,today,tomorrow", startingIndex: 1)
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

extension CustomContainerViewWithSegmentedControl: CustomSegmentedControlDelegate {
    func segmentedButtonPressed(_ button: UIButton) {
        if button.currentTitle == "yesterday" {
            riseContainer.morningTimeLabel.text = "test"
        } else if button.currentTitle == "tomorrow" {
            riseContainer.morningTimeLabel.text = "test2"
        }
        
    }
    
}
