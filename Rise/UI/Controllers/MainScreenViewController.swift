//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController {
    let locationManager = sharedLocationManager
    let networkManager = sharedNetworkManager
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: IBOutlets
    @IBOutlet weak var mainContainerView: CustomContainerView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestLocation()
    }
    @IBAction func buttonTouch(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
//        transitionManager.makeTransition(to: Identifiers.sleep)
        networkManager.getSunData { result in
            switch result {
            case let .success(sunModel):
                print(sunModel.sunrise)
                print(sunModel.sunset)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
}
