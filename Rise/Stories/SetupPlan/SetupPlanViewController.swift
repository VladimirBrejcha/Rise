//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

protocol SetupPlanViewInput: AnyObject {
    func endStory()
}

protocol SetupPlanViewOutput: ViewOutput {
    func schedulePressed()
    
}

enum ChangePlanViewType {
    case info
    case planDuration
    case sleepDuration
    case lastSleepTime
    case preferedWakeUpTime
    case syncWithSun
}

final class SetupPlanViewController:
    UIViewController,
    SetupPlanViewInput,
    UIAdaptivePresentationControllerDelegate
{
    private var pageController: SetupPlanPageViewController!
    
    var output: SetupPlanViewOutput!
    
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var firstStackButton: Button!
    @IBOutlet private weak var nextButton: Button!
    
    var stories: [Story]!
    private var currentPageIndex = 0
    
    private let viewControllers: [UIViewController] = [
        Storyboard.plan.get().instantiateViewController(of: WelcomeSetuplPlanViewController.self),
        Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self),
        Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self),
        Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self),
        Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self),
        Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self)
    ]
    
    private lazy var gradientManager: GradientManager = {
        return GradientManager(frame: view.bounds)
    }()
    
    private lazy var backgroundView: UIView = {
        return gradientManager.createStaticGradient(colors: [#colorLiteral(red: 0.1254607141, green: 0.1326543987, blue: 0.2668849528, alpha: 1), #colorLiteral(red: 0.34746629, green: 0.1312789619, blue: 0.2091784477, alpha: 1)],
                                                    direction: .up,
                                                    alpha: 1)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        presentationController?.delegate = self
        
        updateButtons(pageNumber: currentPageIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let pageController = segue.destination as? SetupPlanPageViewController else { return }
        pageController.setViewControllers([viewControllers[currentPageIndex]], direction: .forward, animated: true, completion: nil)
        self.pageController = pageController
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        output.viewWillDisappear()
    }
    
    @IBAction func closeTouchUp(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backTouchUp(_ sender: Button) {
        if viewControllers.indices.contains(currentPageIndex - 1) {
            currentPageIndex -= 1
            updateButtons(pageNumber: currentPageIndex)
            pageController.setViewControllers([viewControllers[currentPageIndex]], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextTouchUp(_ sender: Button) {
        if viewControllers.indices.contains(currentPageIndex + 1) {
            currentPageIndex += 1
            updateButtons(pageNumber: currentPageIndex)
            pageController.setViewControllers([viewControllers[currentPageIndex]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - SetupPlanViewInput -
    func changeFirstButtonVisibility(visible: Bool) {
        changeViewVisibility(view: firstStackButton, visible: visible)
    }
    
    func changeFirstButtonText(_ text: String) {
        firstStackButton.setTitle(text, for: .normal)
    }
    
    func changeSecondButtonText(_ text: String) {
        nextButton.setTitle(text, for: .normal)
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
    
    private func updateButtons(pageNumber: Int) {
        switch pageNumber {
        case 0:
            firstStackButton.setTitle("", for: .normal)
            nextButton.setTitle("Start", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: false)
            changeViewVisibility(view: nextButton, visible: true)
        case 1:
            firstStackButton.setTitle("", for: .normal)
            nextButton.setTitle("Next", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: false)
            changeViewVisibility(view: nextButton, visible: true)
        case 2:
            firstStackButton.setTitle("Previous", for: .normal)
            nextButton.setTitle("Next", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: true)
            changeViewVisibility(view: nextButton, visible: true)
        case 3:
            firstStackButton.setTitle("Previous", for: .normal)
            nextButton.setTitle("Next", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: true)
            changeViewVisibility(view: nextButton, visible: true)
        case 4:
            firstStackButton.setTitle("Previous", for: .normal)
            nextButton.setTitle("Next", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: true)
            changeViewVisibility(view: nextButton, visible: true)
        case 5:
            firstStackButton.setTitle("Previous", for: .normal)
            nextButton.setTitle("Create", for: .normal)
            changeViewVisibility(view: firstStackButton, visible: true)
            changeViewVisibility(view: nextButton, visible: true)
        default:
            break
        }
    }
}
