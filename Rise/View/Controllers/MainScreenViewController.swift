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
    private var transtitionManager: TransitionManager?

    @IBOutlet weak var mainContainerView: UIView!
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createSegmentedControl()
    }
    
    func createSegmentedControl() {
        let segmentedControl = CustomSegmentedContrl(frame: CGRect(x: 0, y: 0, width: 0, height: 0), buttonTitles: "yesterday,today,tomorrow")
        segmentedControl.backgroundColor = .clear
        
//        segmentedControl.addTarget(self, action: #selector(onChangeOfSegment(_:)), for: .valueChanged)
//        segmentedControl.selectedSegmentIndex = 2
        view.addSubview(segmentedControl)
//        segmentedControl.commaSeperatedButtonTitles = "yesterday,today,tomorrow"
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.heightAnchor.constraint(equalToConstant: 45).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: -3).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: mainContainerView.centerXAnchor).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: mainContainerView.widthAnchor, constant: -20).isActive = true
    }
    
    // MARK: Actions
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        transtitionManager = TransitionManager()
        transtitionManager?.makeTransition(from: self, to: Identifiers.sleep)
    }
    
}
