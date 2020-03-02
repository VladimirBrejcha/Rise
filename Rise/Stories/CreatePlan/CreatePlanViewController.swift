//
//  CreatePlanViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol CreatePlanViewInput: AnyObject {
    func show(views: [UIViewController], forwardDirection: Bool)
    
    func updateBackButtonText(_ text: String)
    func updateNextButtonText(_ text: String)
    func updateBackButtonVisibility(visible: Bool)
    func updateNextButtonVisibility(visible: Bool)
    func enableNextButton(_ enabled: Bool)
    
    func endStory()
}

protocol CreatePlanViewOutput: ViewOutput {
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
    
    @IBAction func closeTouchUp(_ sender: UIButton) {
        output.closeTouchUp()
    }
    
    @IBAction func backTouchUp(_ sender: Button) {
        output.backTouchUp()
    }
    
    @IBAction func nextTouchUp(_ sender: Button) {
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
    
    func updateBackButtonVisibility(visible: Bool) {
        changeViewVisibility(view: backButton, visible: visible)
    }
    
    func updateNextButtonVisibility(visible: Bool) {
        changeViewVisibility(view: nextButton, visible: visible)
    }
    
    func show(views: [UIViewController], forwardDirection: Bool) {
        pageController.setViewControllers(views,
                                          direction: forwardDirection
                                            ? .forward
                                            : .reverse,
                                          animated: true, completion: nil)
    }
    
    func endStory() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate -
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    // MARK: - Private -
    private func changeViewVisibility(view: UIView, visible: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            view.isHidden = !visible
        })
    }
}
