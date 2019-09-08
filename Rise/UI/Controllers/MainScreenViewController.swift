//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import DGActivityIndicatorView

final class MainScreenViewController: UIViewController, LocationManagerDelegate {
    private let locationManager = sharedLocationManager
    private lazy var transitionManager = TransitionManager()
    @IBOutlet weak var mainContainerView: CollectionViewWithSegmentedControl!
    @IBOutlet weak var activityIndicator: DGActivityIndicatorView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestLocation()
        sharedLocationManager.delegate = self
    
//        let blurEffect = UIBlurEffect(style: .light)
//        blurredView.effect = blurEffect
//        blurredView.alpha = 0.95
//
//        activityIndicator.type = .ballScaleMultiple
//        activityIndicator.startAnimating()
        
    }
    @IBAction func buttonTouch(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.sleep)
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
    func newLocationDataArrived(locationModel: LocationModel) {
        NetworkManager.getSunData(location: locationModel, day: .yesterday) { result in // TODO: weakSelf
            switch result {
            case let .success(sunModel):
                self.mainContainerView.timesArray.append(sunModel)
                NetworkManager.getSunData(location: locationModel, day: .today) { result in // TODO: weakSelf
                    switch result {
                    case let .success(sunModel):
                        self.mainContainerView.timesArray.append(sunModel)
                        NetworkManager.getSunData(location: locationModel, day: .tomorrow) { result in // TODO: weakSelf
                            switch result {
                            case let .success(sunModel):
                                self.mainContainerView.timesArray.append(sunModel)
                                self.mainContainerView.collectionView.reloadData()
                            case let .failure(error):
                                print(error.localizedDescription)
                            }
                        }
                    case let .failure(error):
                        print(error.localizedDescription)
                    }
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
