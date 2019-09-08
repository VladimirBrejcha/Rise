//
//  CustomCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var toSleepTimeSleep: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
