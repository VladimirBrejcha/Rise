//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol TodayStoryViewInput: AnyObject {
    func present(controller: UIViewController)
    
    func setupCollectionView(with dataSource: UICollectionViewDataSource)
    func refreshCollectionView()
    
    func makeTabBar(visible: Bool)
}

protocol TodayStoryViewOutput: ViewOutput {

}

final class TodayStoryViewController: UIViewController, TodayStoryViewInput {
    var output: TodayStoryViewOutput!
    
    @IBOutlet private weak var mainContainerView: DaysView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDisappear()
    }
    
    // MARK: - TodayStoryViewInput -
    func present(controller: UIViewController) {
        Presenter.present(controller: controller, with: .overContext, presentingController: self)
    }
    
    func setupCollectionView(with dataSource: UICollectionViewDataSource) {
        mainContainerView.collectionView.dataSource = dataSource
        mainContainerView.collectionView.delegate = mainContainerView
    }
    
    func refreshCollectionView() {
        mainContainerView.collectionView.reloadData()
    }
    
    func makeTabBar(visible: Bool) {        
        UIView.animate(withDuration: 0.15) {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
}
