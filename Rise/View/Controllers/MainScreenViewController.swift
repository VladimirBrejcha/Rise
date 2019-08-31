//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController, CustomSegmentedControlDelegate {
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    
    // MARK: IBOutlets
    @IBOutlet weak var mainContainerView: CustomContainerView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.sleep)
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
    func segmentedButtonPressed(_ segment: SegmentedDate) {
        switch segment {
        case .yesterday:
            print("yesterday")
        case .today:
            print("today")
        case .tomorrow:
            print("tomorrow")
        }
        
    }
    
}
