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
    
    func setupCollection(with dataSource: UICollectionViewDataSource)
    func reloadCollection()
    func reloadItem(at index: Int)
    func reloadItems(at indexes: [Int])
    func getIndexOf(cell: DaysCollectionCell) -> Int?
    
    var timeToSleepDataSource: (() -> (text: String, alpha: Float))? { get set }
    
    func updateDescription(with text: String)
    
    func makeTabBar(visible: Bool)
}

protocol TodayStoryViewOutput: ViewOutput { }

final class TodayStoryViewController: UIViewController, TodayStoryViewInput {
    var output: TodayStoryViewOutput!
    
    @IBOutlet private weak var mainContainerView: DaysView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeToSleepLabel: FloatingLabel!
    
    var timeToSleepDataSource: (() -> (text: String, alpha: Float))? {
        didSet {
            timeToSleepLabel.dataSource = timeToSleepDataSource
        }
    }
    
    private var daysCollectionView: DaysCollectionView {
        mainContainerView.collectionView
    }
    
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
    
    func setupCollection(with dataSource: UICollectionViewDataSource) {
        daysCollectionView.dataSource = dataSource
    }
    
    func getIndexOf(cell: DaysCollectionCell) -> Int? {
        daysCollectionView.indexPath(for: cell)?.row
    }
    
    func reloadItem(at index: Int) {
        DispatchQueue.main.async {
            self.daysCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    func reloadItems(at indexes: [Int]) {
        DispatchQueue.main.async {
            self.daysCollectionView.reloadItems(at: indexes.map { IndexPath(item: $0, section: 0) })
        }
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {
            self.daysCollectionView.reloadData()
        }
    }
    
    func updateDescription(with text: String) {
        descriptionLabel.text = text
    }
    
    func makeTabBar(visible: Bool) {        
        UIView.animate(withDuration: 0.15) {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
}
