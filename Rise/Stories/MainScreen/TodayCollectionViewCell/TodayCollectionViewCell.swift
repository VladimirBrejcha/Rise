//
//  TodayCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var toSleepTimeSleep: UILabel!
    @IBOutlet weak var loadingView: AnimatedLoadingView!
    @IBOutlet weak var sunContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadingView.setupAnimationLayer()
        loadingView.showLoading()
    }
    
    func showContent() {
        loadingView.hideLoading {
            UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
                self.sunContainerView.alpha = 1
            })
        }
    }
}
