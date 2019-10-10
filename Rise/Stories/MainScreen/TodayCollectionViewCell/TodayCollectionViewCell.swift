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
    @IBOutlet weak var sunLoadingView: AnimatedLoadingView!
    @IBOutlet weak var sunContainerView: UIView!
    @IBOutlet weak var planContainerView: UIView!
    @IBOutlet weak var planLoadingView: AnimatedLoadingView!
    
    private var dataManager: CoreDataManager! {
        return sharedCoreDataManager
    }
    
    private var isSunDataLoaded: Bool = false
    private var isPlanDataLoaded: Bool! {
        return dataManager.currentPlan != nil
    }
    
    var cellModel: TodayCellModel! {
        didSet {
            sunriseTimeLabel.text = cellModel.sunriseTime
            sunsetTimeLabel.text = cellModel.sunsetTime
            isSunDataLoaded = cellModel.isDataLoaded
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        sunLoadingView.setupAnimationLayer()
        planLoadingView.setupAnimationLayer()
        
        isSunDataLoaded
            ? sunLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                       animations: { self.sunContainerView.alpha = 1 }) }
            : sunLoadingView.showLoading()
        
        isPlanDataLoaded
            ? planLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                       animations: { self.planContainerView.alpha = 1 }) }
            : planLoadingView.showLoading()
    }
}
