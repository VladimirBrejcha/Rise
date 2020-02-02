//
//  PersonalPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

final class PersonalPlanPresenter: PersonalPlanViewOutput {
    weak var view: PersonalPlanViewInput?
    
    private let getPlan: GetPlan
    private let updatePlan: UpdatePlan
    private let observePlan: ObservePlan
    
    private var personalPlan: PersonalPlan? {
        getPlan.execute()
    }
    
    required init(
        view: PersonalPlanViewInput,
        getPlan: GetPlan,
        updatePlan: UpdatePlan,
        observePlan: ObservePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.updatePlan = updatePlan
        self.observePlan = observePlan
    }
    
    // MARK: - PersonalPlanViewOutput -
    func viewDidLoad() {
        self.updateView(with: personalPlan)
        observePlan.execute({ [weak self] plan in
             self?.updateView(with: plan)
        })
    }
    
    func planPressed() {
        if personalPlan == nil {
            view?.present(controller: Story.setupPlan.configure())
        }
    }
    
    func pausePressed() {
        guard let plan = personalPlan else { return }
        
        let pausedPlan = PersonalPlanHelper.pause(!plan.paused, plan: plan)
        
        if updatePlan.execute(pausedPlan) {
            updateView(with: pausedPlan)
        }
    }
    
    // MARK: - Private -
    private func updateView(with plan: PersonalPlan?) {
        guard let view = view else { return }
        
        if let plan = plan {
            let durationText = "\(PersonalPlanHelper.StringRepresentation.getSleepDurationHours(for: plan)) hours of sleep daily"
            let wakeUpText = "Will wake up at \(PersonalPlanHelper.StringRepresentation.getWakeTime(for: plan))"
            let toSleepText = "Will sleep at \(PersonalPlanHelper.StringRepresentation.getFallAsleepTime(for: plan))"
//            let syncText = "Synchronized with sunrise"
            let syncText = "Coming soon"
            
            view.updateProgressView(with: PersonalPlanHelper.getProgress(for: plan), maxProgress: PersonalPlanHelper.StringRepresentation.getPlanDuration(for: plan))
            view.updatePlanInfo(with: [durationText, wakeUpText, toSleepText, syncText])
            view.updatePauseTitle(with: plan.paused ? "Resume" : "Pause")
            view.pausePerformance(plan.paused)
        }
        view.updateUI(doesPlanExist: plan != nil)
        view.updateStackViewButtons(doesPlanExist: plan != nil)
    }
}
