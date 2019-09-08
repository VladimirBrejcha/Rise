//
//  CustomCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var toSleepTimeSleep: UILabel!
    @IBOutlet weak var sunBlurView: UIView!
    @IBOutlet weak var sunContainerView: UIView!
    @IBOutlet weak var sunActivityIndicatorView: DGActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sunBlurView.backgroundColor = sunContainerView.backgroundColor
        sunActivityIndicatorView.type = .ballScaleMultiple
        sunActivityIndicatorView.startAnimating()
    }
    
    func showContent() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
            self.sunActivityIndicatorView.alpha = 0.0
        }) { completed in
            self.sunActivityIndicatorView.stopAnimating()
            UIView.animate(withDuration: 0.8, delay: 0, options: .allowUserInteraction, animations: {
                self.sunContainerView.alpha = 1.0
                self.sunBlurView.alpha = 0.0
            })
        }
    }
}
