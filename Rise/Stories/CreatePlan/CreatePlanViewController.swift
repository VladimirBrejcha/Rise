//
//  CreatePlanViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CreatePlanViewController:
    UIViewController,
    UIAdaptivePresentationControllerDelegate,
    ErrorAlertCreatable,
    ErrorAlertPresentable
{
    @IBOutlet private var createPlanView: CreatePlanView!
    
    private var pageController: UIPageViewController!

    var createSchedule: CreateSchedule! // DI
    var saveSchedule: SaveSchedule! // DI
    var stories: [Story]! // DI
    
    // opened for DI into PageController controllers
    private(set) var choosenSleepDuration: Int?
    private(set) var choosenWakeUpTime: Date?
    private(set) var choosenLastTimeWentSleep: Date?
    
    private var currentPage = 0
    private var currentStory: Story { stories[currentPage] }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentationController?.delegate = self
        
        createPlanView.configure(
            model: CreatePlanView.Model(backButtonTitle: "", nextButtonTitle: "Start"),
            handlers: CreatePlanView.Handlers(
                close: { [weak self] in
                    self?.dismiss()
                },
                back: { [weak self] in
                    guard let self = self else { return }
                    if self.stories.indices.contains(self.currentPage - 1) {
                        self.currentPage -= 1
                        self.showNextStory(direction: .reverse)
                        self.updateButtonsWithCurrentStory()
                    }
                },
                next: { [weak self] in
                    guard let self = self else { return }
                    if case .planCreatedSetupPlan = self.currentStory {
                        self.dismiss()
                        return
                    }
                    if case .wentSleepCreatePlan = self.currentStory {
                        do {
                            try self.generatePlan()
                        } catch {
                            self.presentAlert(
                                from: RecoverableError(
                                    error: error,
                                    attempter: RecoveryAttemper(
                                        recoveryOptions: [
                                            .custom(
                                                title: "Leave Create screen",
                                                action: { [weak self] in
                                                    log(.error, "There was an error creating the plan \(error.localizedDescription)")
                                                    self?.dismiss()
                                                }
                                            ),
                                            .tryAgain(
                                                action: {
                                                    log(.error, "There was an error creating the plan \(error.localizedDescription)")
                                                }
                                            )
                                        ]
                                    )
                                )
                            )
                            return
                        }
                    }
                    if self.stories.indices.contains(self.currentPage + 1) {
                        self.currentPage += 1
                        self.showNextStory(direction: .forward)
                        self.updateButtonsWithCurrentStory()
                    }
                }
            )
        )
        showNextStory(direction: .forward)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pageController = segue.destination as? UIPageViewController {
            self.pageController = pageController
        }
    }
    
    // opened for DI into PageController controllers
    func sleepDurationValueChanged(_ value: Int) {
        choosenSleepDuration = value
        updateButtonsWithCurrentStory()
    }
    
    func wakeUpTimeValueChanged(_ value: Date) {
        choosenWakeUpTime = value
        updateButtonsWithCurrentStory()
    }
    
    func lastTimeWentSleepValueChanged(_ value: Date) {
        choosenLastTimeWentSleep = value
        updateButtonsWithCurrentStory()
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate -
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    // MARK: - Private -
    private func dismiss() {
        dismiss(animated: true)
    }
    
    private func showNextStory(direction: UIPageViewController.NavigationDirection) {
        pageController.setViewControllers([currentStory()], direction: direction, animated: true, completion: nil)
    }
    
    private func updateButtonsWithCurrentStory() {
        switch currentStory {
        case .welcomeCreatePlan:
            createPlanView.state = CreatePlanView.State(nextButtonEnabled: true, backButtonHidden: true)
            createPlanView.model = CreatePlanView.Model(backButtonTitle: "", nextButtonTitle: "Start")
        case .sleepDurationCreatePlan:
            createPlanView.state = CreatePlanView.State(
                nextButtonEnabled: choosenSleepDuration != nil,
                backButtonHidden: true
            )
            createPlanView.model = CreatePlanView.Model(backButtonTitle: "", nextButtonTitle: "Next")
        case .wakeUpTimeCreatePlan:
            createPlanView.state = CreatePlanView.State(
                nextButtonEnabled: choosenWakeUpTime != nil,
                backButtonHidden: false
            )
            createPlanView.model = CreatePlanView.Model(backButtonTitle: "Previous", nextButtonTitle: "Next")
        case .wentSleepCreatePlan:
            createPlanView.state = CreatePlanView.State(
                nextButtonEnabled: choosenLastTimeWentSleep != nil,
                backButtonHidden: false
            )
            createPlanView.model = CreatePlanView.Model(backButtonTitle: "Previous", nextButtonTitle: "Create")
        case .planCreatedSetupPlan:
            createPlanView.state = CreatePlanView.State(nextButtonEnabled: true, backButtonHidden: true)
            createPlanView.model = CreatePlanView.Model(backButtonTitle: "", nextButtonTitle: "Great!")
        default:
            break
        }
    }
    
    private func generatePlan() throws {
        if let choosenSleepDuration = choosenSleepDuration,
            let choosenWakeUpTime = choosenWakeUpTime,
            let choosenLastTimeWentSleep = choosenLastTimeWentSleep {
            let schedule = createSchedule( // todo: save
                wantedSleepDuration: choosenSleepDuration,
                currentToBed: choosenLastTimeWentSleep,
                wantedToBed: choosenWakeUpTime, // todo
                intensity: .normal // todo
            )
            saveSchedule(schedule)
        } else {
            throw PlanError.someFieldsAreMissing // todo
        }
    }
}

