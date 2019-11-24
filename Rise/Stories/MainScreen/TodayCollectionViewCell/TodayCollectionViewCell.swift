//
//  TodayCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

struct TodayCellModel {
    var day: Date
    var sunTime: (sunrise: String, sunset: String)?
    var planTime: (wake: String, sleep: String)?
    var sunErrorMessage: String?
    var planErrorMessage: String?
    
    mutating func update(sunTime: DailySunTime) {
        self.sunTime = (sunrise: DatesConverter.formatDateToHHmm(date: sunTime.sunrise),
                        sunset: DatesConverter.formatDateToHHmm(date: sunTime.sunset))
        sunErrorMessage = nil
    }
    
    mutating func update(planTime: DailyPlanTime) {
        self.planTime = (wake: DatesConverter.formatDateToHHmm(date: planTime.wake),
                         sleep: DatesConverter.formatDateToHHmm(date: planTime.sleep))
        planErrorMessage = nil
    }
}

class TodayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sunriseTimeLabel: UILabel!
    @IBOutlet weak var sunsetTimeLabel: UILabel!
    @IBOutlet weak var wakeUpTimeLabel: UILabel!
    @IBOutlet weak var toSleepTimeLabel: UILabel!
    @IBOutlet weak var sunLoadingView: LoadingView!
    @IBOutlet weak var sunContainerView: UIView!
    @IBOutlet weak var planContainerView: UIView!
    @IBOutlet weak var planLoadingView: LoadingView!
    
    private var isSunDataLoaded: Bool {
        return cellModel.sunTime != nil
    }
    private var isPlanDataLoaded: Bool {
        return cellModel.planTime != nil
    }
    
    private var sunError: String?
    private var planError: String?
    
    var cellModel: TodayCellModel! {
        didSet {
            sunriseTimeLabel.text = cellModel.sunTime?.sunrise
            sunsetTimeLabel.text = cellModel.sunTime?.sunset
            wakeUpTimeLabel.text = cellModel.planTime?.wake
            toSleepTimeLabel.text = cellModel.planTime?.sleep
            sunError = cellModel.sunErrorMessage
            planError = cellModel.sunErrorMessage
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        sunLoadingView.setupAnimationLayer()
        planLoadingView.setupAnimationLayer()
        
        if let error = sunError {
            sunLoadingView.showInfo(with: error)
        } else {
            sunLoadingView.hideInfo()
            isSunDataLoaded
                ? sunLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                              animations: { self.sunContainerView.alpha = 1 }) }
                : sunLoadingView.showLoading()
        }
        
        if let error = planError {
            planLoadingView.showInfo(with: error)
        } else {
            planLoadingView.hideInfo()
            
            isPlanDataLoaded
                ? planLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                               animations: { self.planContainerView.alpha = 1 }) }
                : planLoadingView.showLoading()
        }
    }
}
