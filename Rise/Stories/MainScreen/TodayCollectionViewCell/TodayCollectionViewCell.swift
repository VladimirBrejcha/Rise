//
//  TodayCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

struct TodayCellModel {
    var isDataLoaded: Bool
    var sunriseTime: String
    var sunsetTime: String
}

class TodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var toSleepTimeSleep: UILabel!
    @IBOutlet weak var loadingView: AnimatedLoadingView!
    @IBOutlet weak var sunContainerView: UIView!
    
    private var isDataLoaded: Bool = false
    
    var cellModel: TodayCellModel! {
        didSet {
            sunriseTimeLabel.text = cellModel.sunriseTime
            sunsetTimeLabel.text = cellModel.sunsetTime
            isDataLoaded = cellModel.isDataLoaded
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        loadingView.setupAnimationLayer()
        
        isDataLoaded
            ? loadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                       animations: { self.sunContainerView.alpha = 1 }) }
            : loadingView.showLoading()
    }
}
