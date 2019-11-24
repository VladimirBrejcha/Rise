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
}

protocol MainScreenViewOutput: AnyObject {
    func viewDidLoad()
    func viewDidAppear()
}

final class MainScreenViewController: UIViewController, MainScreenViewInput {
    @IBOutlet weak var mainContainerView: CollectionViewWithSegmentedControl!
    var presenter: MainScreenViewOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainScreenPresenter(view: self)
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }
    
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
    }
    
    // MARK: - MainScreenViewInput
    func setupCollectionView(with dataSource: UICollectionViewDataSource) {
        mainContainerView.collectionView.dataSource = dataSource
        mainContainerView.collectionView.delegate = mainContainerView
    }
    
    func refreshCollectionView() { mainContainerView.collectionView.reloadData() }
    
    func showSunTimeLoadingError() {
        
    }
    
    func showError(with text: String) { UIHelper.showError(errorMessage: text) }
    
}
