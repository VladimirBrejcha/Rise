//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol TodayStoryViewInput: AnyObject {
    func present(controller: UIViewController, with presentationStyle: PresentationStyle) 
    
    func setupCollection(with dataSource: UICollectionViewDataSource)
    func reloadCollection()
    func reloadItem(at index: Int)
    func reloadItems(at indexes: [Int])
    func getIndexOf(cell: DaysCollectionCell) -> Int?
    
    var timeToSleepDataSource: (() -> FloatingLabelModel)? { get set }
    
    func updateDescription(with text: String)
    
    func makeTabBar(visible: Bool)
}

protocol TodayStoryViewOutput: ViewControllerLifeCycle {
    func sleepPressed()
}

final class TodayStoryViewController: UIViewController, TodayStoryViewInput {
    var output: TodayStoryViewOutput!
    
    @IBOutlet private weak var mainContainerView: DaysView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeToSleepLabel: FloatingLabel!
    
    var timeToSleepDataSource: (() -> FloatingLabelModel)? {
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
    
    @IBAction private func sleepTouchUp(_ sender: Button) {
        output.sleepPressed()
    }
    
    // MARK: - TodayStoryViewInput -
    func present(controller: UIViewController, with presentationStyle: PresentationStyle) {
        Presenter.present(controller: controller, with: presentationStyle, presentingController: self)
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
