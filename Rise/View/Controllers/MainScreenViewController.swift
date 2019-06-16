//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import SPStorkController

final class MainScreenViewController: UIViewController {
    
    // MARK: Properties
    private var transtitionManager: TransitionManager?
    @IBOutlet weak var iconForAnimation: UIImageView!
    
    @IBOutlet weak var mainContainerView: CustomContainerView!
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createSegmentedControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func createSegmentedControl() {
        let segmentedControl = CustomSegmentedContrl(buttonTitles: "yesterday,today,tomorrow", startingIndex: 1)
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
        iconForAnimation.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
        }) { (true) in
            self.transtitionManager = TransitionManager()
            self.transtitionManager?.makeTransition(from: self, to: Identifiers.sleep)
        }
        
        
    }
    
}

extension MainScreenViewController: SPStorkControllerDelegate {
    func didDismissStorkBySwipe() {
        UIView.animate(withDuration: 2) {
            self.view.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.07450980392, blue: 0.1568627451, alpha: 1)
            self.view.backgroundColor = .clear
        }
        
        
    }
}
