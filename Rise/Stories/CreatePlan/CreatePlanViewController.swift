//
//  CreatePlanViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol CreatePlanViewInput: AnyObject {
    func show(views: [UIViewController], forwardDirection: Bool)
    
    func updateBackButtonText(_ text: String)
    func updateNextButtonText(_ text: String)
    func showBackButton(_ show: Bool)
    func enableNextButton(_ enabled: Bool)
    
    func endStory()
}

protocol CreatePlanViewOutput: ViewControllerLifeCycle {
    func backTouchUp()
    func nextTouchUp()
    func closeTouchUp()
}

final class CreatePlanViewController:
    UIViewController,
    CreatePlanViewInput,
    UIAdaptivePresentationControllerDelegate
{
    var output: CreatePlanViewOutput!
    
    private var pageController: CreatePlanPageViewController!
    
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var backButton: Button!
    @IBOutlet private weak var nextButton: Button!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = GradientHelper.makeDefaultStaticGradient(for: view.bounds)
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        presentationController?.delegate = self
        
        output.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageController = segue.destination as? CreatePlanPageViewController {
            self.pageController = pageController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    @IBAction private func closeTouchUp(_ sender: UIButton) {
        output.closeTouchUp()
    }
    
    @IBAction private func backTouchUp(_ sender: Button) {
        output.backTouchUp()
    }
    
    @IBAction private func nextTouchUp(_ sender: Button) {
        output.nextTouchUp()
    }
    
    // MARK: - SetupPlanViewInput -
    func updateBackButtonText(_ text: String) {
        backButton.setTitle(text, for: .normal)
    }
    
    func enableNextButton(_ enabled: Bool) {
        nextButton.isEnabled = enabled
    }
    
    func updateNextButtonText(_ text: String) {
        nextButton.setTitle(text, for: .normal)
    }
    
    func showBackButton(_ show: Bool) {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.backButton.isHidden = !show
        }
        animator.startAnimation()
    }
    
    func show(views: [UIViewController], forwardDirection: Bool) {
        pageController.setViewControllers(views,
                                          direction: forwardDirection ? .forward : .reverse,
                                          animated: true, completion: nil)
    }
    
    func endStory() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate -
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
