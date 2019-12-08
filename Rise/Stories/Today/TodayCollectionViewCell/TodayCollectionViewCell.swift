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

protocol TodayCollectionViewCellDelegate: AnyObject {
    func repeatButtonPressed(on cell: TodayCollectionViewCell)
}

class TodayCollectionViewCell: UICollectionViewCell, LoadingViewDelegate {
    weak var delegate: TodayCollectionViewCellDelegate?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sunLoadingView.delegate = self
    }
    
    var cellModel: TodayCellModel! {
        didSet {
            sunriseTimeLabel.text = cellModel.sunTime?.sunrise
            sunsetTimeLabel.text = cellModel.sunTime?.sunset
            wakeUpTimeLabel.text = cellModel.planTime?.wake
            toSleepTimeLabel.text = cellModel.planTime?.sleep
        }
    }
    
    func repeatButtonPressed() {
        delegate?.repeatButtonPressed(on: self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        sunLoadingView.setupAnimationLayer()
        planLoadingView.setupAnimationLayer()
        
        cellModel.sunErrorMessage != nil
            ? { sunLoadingView.showLoadingError() }()

            : { sunLoadingView.hideError()
                isSunDataLoaded
                    ? sunLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                                  animations: { self.sunContainerView.alpha = 1 })}
                    : sunLoadingView.showLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                                  animations: { self.sunContainerView.alpha = 0 })} }()
            
        cellModel.planErrorMessage != nil
            ? { self.planContainerView.alpha = 0
                planLoadingView.showInfo(with: cellModel.planErrorMessage!) }()
                
            : { planLoadingView.hideInfo()
                isPlanDataLoaded
                    ? planLoadingView.hideLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                                   animations: { self.planContainerView.alpha = 1 }) }
                    : planLoadingView.showLoading { UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                                                                   animations: { self.planContainerView.alpha = 0 })} }()
    }
}
