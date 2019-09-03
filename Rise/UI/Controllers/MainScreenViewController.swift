//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController, LocationManagerDelegate {
    private let locationManager = sharedLocationManager
    private lazy var transitionManager = TransitionManager()
    @IBOutlet weak var mainContainerView: CustomContainerViewWithSegmentedControl!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestLocation()
        sharedLocationManager.delegate = self
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
        NetworkManager.getSunData(location: locationModel, day: .today) { result in // TODO: weakSelf
            switch result {
            case let .success(sunModel):
                self.mainContainerView.riseContainer.morningTimeLabel.text = DatesConverter.formatDateToHHmm(date: sunModel.sunrise)
                self.mainContainerView.riseContainer.eveningTimeLabel.text = DatesConverter.formatDateToHHmm(date: sunModel.sunset)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}
