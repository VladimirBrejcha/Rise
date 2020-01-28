//
//  TodayCollectionViewCell.swift
//  Rise
//
//  Created by Владимир Королев on 07/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol DaysCollectionViewCellDelegate: AnyObject {
    func repeatButtonPressed(on cell: DaysCollectionViewCell)
}

final class DaysCollectionViewCell: UICollectionViewCell {
    weak var delegate: DaysCollectionViewCellDelegate?
    
    @IBOutlet private weak var sunriseTimeLabel: UILabel!
    @IBOutlet private weak var sunsetTimeLabel: UILabel!
    
    @IBOutlet private weak var wakeUpTimeLabel: UILabel!
    @IBOutlet private weak var toSleepTimeLabel: UILabel!
    
    @IBOutlet private weak var sunContainerView: UIView!
    @IBOutlet private weak var sunLoadingView: LoadingView!
    
    @IBOutlet private weak var planContainerView: UIView!
    @IBOutlet private weak var planLoadingView: LoadingView!
    
    private var isSunDataLoaded: Bool {
        return cellModel.sunTime != nil
    }
    private var isPlanDataLoaded: Bool {
        return cellModel.planTime != nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sunLoadingView.repeatButtonHandler = repeatButtonPressed
        planLoadingView.repeatButtonHandler = repeatButtonPressed
    }
    
    var cellModel: DaysCollectionViewCellModel! {
        didSet {
            sunriseTimeLabel.text = cellModel.sunTime?.sunrise
            sunsetTimeLabel.text = cellModel.sunTime?.sunset
            wakeUpTimeLabel.text = cellModel.planTime?.wake
            toSleepTimeLabel.text = cellModel.planTime?.sleep
        }
    }
    
    private func repeatButtonPressed() {
        delegate?.repeatButtonPressed(on: self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        cellModel.sunErrorMessage != nil
            ? { self.sunContainerView.alpha = 0
                sunLoadingView.showError(true) }()
            : { sunLoadingView.showError(false)
                sunLoadingView.showLoading(!isSunDataLoaded) {
                    UIView.animate(withDuration:Rise/Helpers/AnimationManager.swift 0.6, delay: 0,
                                   options: .allowUserInteraction,
                                   animations:
                        { self.sunContainerView.alpha = self.isSunDataLoaded ? 1 : 0 })
                }
            }()
        
        cellModel.planErrorMessage != nil
            ? { self.planContainerView.alpha = 0
                planLoadingView.showInfo(with: cellModel.planErrorMessage!) }()
            : { self.planContainerView.alpha = 1
                planLoadingView.hideInfo()
                planLoadingView.showLoading(!isPlanDataLoaded) {
                    UIView.animate(withDuration: 0.6, delay: 0,
                                   options: .allowUserInteraction,
                                   animations:
                        { self.planLoadingView.alpha = self.isPlanDataLoaded ? 1 : 0 })
                }
            }()
    }
}
