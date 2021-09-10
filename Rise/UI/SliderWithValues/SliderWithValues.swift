//
//  SliderWithValues.swift
//  Rise
//
//  Created by Vladimir Korolev on 01.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
final class SliderWithValues: UIView, NibLoadable {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    var centerLabelDataSource: ((Float) -> String)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }
    
    @IBAction private func valueChanged(_ sender: UISlider) {
        centerLabel.text = centerLabelDataSource?(sender.value)
    }
}
