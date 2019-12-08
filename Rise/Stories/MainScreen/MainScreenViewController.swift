//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol MainScreenViewInput: AnyObject {
    func setupCollectionView(with dataSource: UICollectionViewDataSource)
    func refreshCollectionView()
    func showSunTimeLoadingError()
    func showError(with text: String)
    func presentPopOver(controllerID: String)
    func showTabBar(_ show: Bool)
}

protocol MainScreenViewOutput: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
}

final class MainScreenViewController: UIViewController, MainScreenViewInput {
    @IBOutlet weak var mainContainerView: CollectionViewWithSegmentedControl!
    var output: MainScreenViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - MainScreenViewInput
    func setupCollectionView(with dataSource: UICollectionViewDataSource) {
        mainContainerView.collectionView.dataSource = dataSource
        mainContainerView.collectionView.delegate = mainContainerView
    }
    
    func refreshCollectionView() {
        mainContainerView.collectionView.reloadData()
    }
    
    func showSunTimeLoadingError() {
        
    }
    
    func showError(with text: String) {
        UIHelper.showError(errorMessage: text)
    }
    
    func showTabBar(_ show: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.tabBarController?.tabBar.isHidden = !show
        }
    }
    
    func presentPopOver(controllerID: String) {
        performSegue(withIdentifier: controllerID, sender: self)
    }
}
