//
//  SetupPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class SetupPlanPresenter: SetupPlanViewOutput {
    weak var view: SetupPlanViewInput!
    
    private let savePersonalPlanUseCase: SavePersonalPlanUseCase = sharedUseCaseManager
    
    private var choosenSleepDuration: Int?
    private var choosenWakeUpTime: Date?
    private var choosenPlanDuration: Int?
    private var choosenLastTimeWentSleep: Date?
    private var planGenerated = false
    
    var stories: [Story]!
    private var currentPage = 0
    private var currentStory: Story { stories[currentPage] }
    
    required init(view: SetupPlanViewInput) { self.view = view }
    
    // MARK: - SetupPlanViewOutput -
    func viewDidLoad() {
        updateButtons(story: currentStory)
        view.showStory(story: currentStory, forwardDirection: true)
    }
    
    func backTouchUp() {
        if stories.indices.contains(currentPage - 1) {
            currentPage -= 1
            updateButtons(story: currentStory)
            view.showStory(story: currentStory, forwardDirection: false)
        }
    }
    
    func nextTouchUp() {
        if case .planCreatedSetupPlan = currentStory {
            view.endStory()
            return
        }
        
        if case .wentSleepSetupPlan = currentStory {
            if !planGenerated {
                planGenerated = generatePlan()
            }
        }
        
        if stories.indices.contains(currentPage + 1) {
            currentPage += 1
            updateButtons(story: currentStory)
            view.showStory(story: currentStory, forwardDirection: true)
        }
    }
    
    func closeTouchUp() {
        view.endStory()
    }
    
    func sleepDurationValueChanged(_ value: Int) {
        choosenSleepDuration = value
        view.enableNextButton(true)
    }
    
    func wakeUpTimeValueChanged(_ value: Date) {
        choosenWakeUpTime = value
        view.enableNextButton(true)
    }
    
    func planDurationValueChanged(_ value: Int) {
        choosenPlanDuration = value
        view.enableNextButton(true)
    }
    
    func lastTimeWentSleepValueChanged(_ value: Date) {
        choosenLastTimeWentSleep = value
        view.enableNextButton(true)
    }
    
    // MARK: - Private -
    private func updateButtons(story: Story) {
        switch story {
        case .welcomeSetupPlan:
            view.updateBackButtonText("")
            view.updateNextButtonText("Start")
            view.updateBackButtonVisibility(visible: false)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(true)
        case .sleepDurationSetupPlan:
            view.updateBackButtonText("")
            view.updateNextButtonText("Next")
            view.updateBackButtonVisibility(visible: false)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(choosenSleepDuration != nil)
        case .wakeUpTimeSetupPlan:
            view.updateBackButtonText("Previous")
            view.updateNextButtonText("Next")
            view.updateBackButtonVisibility(visible: true)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(choosenWakeUpTime != nil)
        case .planDurationSetupPlan:
            view.updateBackButtonText("Previous")
            view.updateNextButtonText("Next")
            view.updateBackButtonVisibility(visible: true)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(choosenPlanDuration != nil)
        case .wentSleepSetupPlan:
            view.updateBackButtonText("Previous")
            view.updateNextButtonText("Create")
            view.updateBackButtonVisibility(visible: true)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(choosenLastTimeWentSleep != nil)
        case .planCreatedSetupPlan:
            view.updateBackButtonText("")
            view.updateNextButtonText("Great!")
            view.updateBackButtonVisibility(visible: false)
            view.updateNextButtonVisibility(visible: true)
            view.enableNextButton(true)
        default:
            break
        }
    }
    
    private func generatePlan() -> Bool {
        guard let choosenSleepDuration = choosenSleepDuration,
            let choosenWakeUpTime = choosenWakeUpTime,
            let choosenPlanDuration = choosenPlanDuration,
            let choosenLastTimeWentSleep = choosenLastTimeWentSleep
            else { return false }
        
        let plan = PersonalPlanConfigurator.configure(sleepDuration: choosenSleepDuration,
                                                      wakeUpTime: choosenWakeUpTime,
                                                      planDuration: choosenPlanDuration,
                                                      wentSleepTime: choosenLastTimeWentSleep)
        return savePersonalPlanUseCase.save(plan: plan)
    }
}
