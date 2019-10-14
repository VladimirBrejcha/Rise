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
    
    private let repository: RiseRepository = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestLocation()
        sharedLocationManager.delegate = self
    }
    
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
    }
    
    func newLocationDataArrived(locationModel: LocationModel) {
        repository.requestSunForecast(for: 3, at: Date(), with: locationModel) { result in
            if case .failure (let error) = result { print(error.localizedDescription) }
            else if case .success (let sunModelArray) = result {
                self.mainContainerView.updateView(with: sunModelArray.sorted { $0.day < $1.day })
            }
        }
    }
    
}
