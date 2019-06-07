//
//  AlarmViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import SPStorkController
import NotificationBannerSwift

class MainScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.backgroundColor = .clear
    }
    
    @IBAction func sleepButtonTouch(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.Storyboard.name, bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: Constants.Identifiers.sleep)
        
        let transitionDelegate = SPStorkTransitioningDelegate()
        
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        transitionDelegate.storkDelegate = self
        
        self.present(controller, animated: true, completion: nil)
    }
    
}

extension MainScreenViewController: SPStorkControllerDelegate {
    
    func didDismissStorkBySwipe() {
        let banner = StatusBarNotificationBanner(title: "Saved", style: .success)
        banner.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        banner.show()
    }
}
