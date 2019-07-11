//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    // MARK: Properties
    private lazy var transitionManager = TransitionManager()
    private var segmentedControl: CustomSegmentedContrl!
    
    // MARK: IBOutlets
    @IBOutlet weak var mainContainerView: CustomContainerView!
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()
    }
    
    // MARK: UISetup Methods
    private func setupSegmentedControl() {
        
        segmentedControl = CustomSegmentedContrl(buttonTitles: "yesterday,today,tomorrow", startingIndex: 1)
        segmentedControl.backgroundColor = .clear
        
        //        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -8).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -20).isActive = true
    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transitionManager.makeTransition(to: Identifiers.sleep)
    }
    
    func didDismissStorkBySwipe() {
        transitionManager.animateBackground()
    }
    
}
