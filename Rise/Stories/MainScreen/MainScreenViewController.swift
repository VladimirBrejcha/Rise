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
    @IBOutlet weak var mainContainerView: CollectionViewWithSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestLocation()
        sharedLocationManager.delegate = self
    }
    
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
    }
    
    func newLocationDataArrived(locationModel: LocationModel) {
        NetworkManager.getSunData(location: locationModel, day: .yesterday) { [weak self] result in
            switch result {
            case let .success(sunModel):
                self?.mainContainerView.timesArray.append(sunModel)
                NetworkManager.getSunData(location: locationModel, day: .today) { result in
                    switch result {
                    case let .success(sunModel):
                        self?.mainContainerView.timesArray.append(sunModel)
                        NetworkManager.getSunData(location: locationModel, day: .tomorrow) { result in
                            switch result {
                            case let .success(sunModel):
                                self?.mainContainerView.timesArray.append(sunModel)
                                self?.mainContainerView.collectionView.reloadData()
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
