//
//  CreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class CreateScheduleViewController:
    UIViewController,
    UIAdaptivePresentationControllerDelegate,
    AlertCreatable,
    AlertPresentable
{
    @IBOutlet private var createScheduleView: CreateScheduleView!
    
    private var pageController: UIPageViewController!

    var createSchedule: CreateSchedule! // DI
    var saveSchedule: SaveSchedule! // DI
    var stories: [Story]! // DI
    var onCreate: (() -> Void)? // DI
    
    // opened for DI into PageController controllers

    private(set) var chosenSleepDuration: Schedule.Minute = 8 * 60
    private(set) var chosenWakeUpTime: Date?
    private(set) var chosenToBedTime: Date?
    private(set) var chosenIntensity: Schedule.Intensity = .normal
    private(set) var chosenLastTimeWentSleep: Date?
    
    private var currentPage = 0
    private var currentStory: Story { stories[currentPage] }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentationController?.delegate = self
        
        createScheduleView.configure(
            model: .init(
                backButtonTitle: "",
                nextButtonTitle: "Start"
            ),
            handlers: .init(
                close: { [weak self] in
                    self?.dismiss()
                },
                back: { [weak self] in
                    self?.goToPrevPage()
                },
                next: { [weak self] in
                    guard let self = self else { return }
                    switch self.currentStory {
                    case .scheduleCreatedCreateSchedule:
                        self.dismiss(completion: { [weak self] in
                            self?.onCreate?()
                        })
                    case .wentSleepCreateSchedule:
                        do {
                            try self.generateSchedule()
                            self.goToNextPage()
                        } catch {
                            self.presentAlert(
                                from: self.recoverableError(from: error)
                            )
                        }
                    default:
                        self.goToNextPage()
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

    func sleepDurationValueChanged(_ value: Schedule.Minute) {
        chosenSleepDuration = value
        updateButtonsWithCurrentStory()
    }
    
    func wakeUpTimeValueChanged(_ value: Date) {
        chosenWakeUpTime = value
        updateButtonsWithCurrentStory()
    }

    func toBedTimeValueChanged(_ value: Date) {
        chosenToBedTime = value
    }

    func intensityValueChanged(_ value: Schedule.Intensity) {
        chosenIntensity = value
        updateButtonsWithCurrentStory()
    }
    
    func lastTimeWentSleepValueChanged(_ value: Date) {
        chosenLastTimeWentSleep = value
        updateButtonsWithCurrentStory()
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate -

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    // MARK: - Private -

    private func dismiss(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }

    private func goToPrevPage() {
        if stories.indices.contains(currentPage - 1) {
            currentPage -= 1
            showNextStory(direction: .reverse)
            updateButtonsWithCurrentStory()
        }
    }

    private func goToNextPage() {
        if stories.indices.contains(currentPage + 1) {
            currentPage += 1
            showNextStory(direction: .forward)
            updateButtonsWithCurrentStory()
        }
    }
    
    private func showNextStory(direction: UIPageViewController.NavigationDirection) {
        pageController.setViewControllers([currentStory()], direction: direction, animated: true)
    }
    
    private func updateButtonsWithCurrentStory() {
        let next = "Next"
        let prev = "Previous"
        switch currentStory {
        case .welcomeCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: true,
                backButtonHidden: true
            )
            createScheduleView.model = .init(
                backButtonTitle: "",
                nextButtonTitle: "Start"
            )
        case .sleepDurationCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: true,
                backButtonHidden: true
            )
            createScheduleView.model = .init(
                backButtonTitle: "",
                nextButtonTitle: next
            )
        case .wakeUpTimeCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: chosenWakeUpTime != nil,
                backButtonHidden: false
            )
            createScheduleView.model = .init(
                backButtonTitle: prev,
                nextButtonTitle: next
            )
        case .intensityCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: true,
                backButtonHidden: false
            )
            createScheduleView.model = .init(
                backButtonTitle: prev,
                nextButtonTitle: next
            )
        case .wentSleepCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: chosenLastTimeWentSleep != nil,
                backButtonHidden: false
            )
            createScheduleView.model = .init(
                backButtonTitle: prev,
                nextButtonTitle: "Create"
            )
        case .scheduleCreatedCreateSchedule:
            createScheduleView.state = .init(
                nextButtonEnabled: true,
                backButtonHidden: true
            )
            createScheduleView.model = .init(
                backButtonTitle: "",
                nextButtonTitle: "Great!"
            )
        default:
            break
        }
    }
    
    private func generateSchedule() throws {
        if let chosenToBedTime = chosenToBedTime,
           let chosenLastTimeWentSleep = chosenLastTimeWentSleep {
            saveSchedule(
                createSchedule(
                    wantedSleepDuration: chosenSleepDuration,
                    currentToBed: chosenLastTimeWentSleep,
                    wantedToBed: chosenToBedTime,
                    intensity: chosenIntensity
                )
            )
        } else {
            throw Error.someFieldsAreMissing
        }
    }
}

extension CreateScheduleViewController {
    enum Error: LocalizedError {
        case someFieldsAreMissing

        var errorDescription: String? {
            switch self {
            case .someFieldsAreMissing:
                return "Could'not generate the schedule because some fields were missing, please try again"
            }
        }
        var recoverySuggestion: String? {
            switch self {
            case .someFieldsAreMissing:
                return "Try to fill all the fields"
            }
        }
    }

    func recoverableError(from error: Swift.Error) -> RecoverableError {
        RecoverableError(
            error: error,
            attempter: RecoveryAttempter(
                recoveryOptions: [
                    .custom(
                        title: "Leave Create screen",
                        action: { [weak self] in
                            log(
                                .error,
                                "There was an error creating the schedule \(error.localizedDescription)"
                            )
                            self?.dismiss()
                        }
                    ),
                    .tryAgain(
                        action: {
                            log(
                                .error,
                                "There was an error creating the schedule \(error.localizedDescription)"
                            )
                        }
                    )
                ]
            )
        )
    }
}

