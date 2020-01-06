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
    private let observePlan: ObservePlan
    
    private var personalPlan: PersonalPlan? {
        getPlan.execute((), completion: ())
    }
    
    private var sleepDurationHours: Double? {
        guard let plan = personalPlan else { return nil }
        return plan.sleepDuration / 3600
    }
    
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    required init(
        view: PersonalPlanViewInput,
        getPlan: GetPlan,
        observePlan: ObservePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.observePlan = observePlan
    }
    
    // MARK: - PersonalPlanViewOutput -
    func viewDidLoad() {
        self.updateView(with: personalPlan)
        observePlan.execute({ [weak self] plan in
             self?.updateView(with: plan)
        }, completion: ())
    }
    
    func changeButtonPressed() {
        
    }
    
    // MARK: - Private -
    private func updateView(with plan: PersonalPlan?) {
        guard let view = view else { return }
        
        if let plan = plan {
            let durationText = "\(plan.sleepDurationHours) hours of sleep daily"
            let wakeUpText = "Will wake up at \(plan.wakeUpAt)"
            let toSleepText = "Will sleep at \(plan.willSleep)"
            let syncText = "Synchronized with sunrise"
            
            view.updateProgressView(with: plan.planProgress, maxProgress: plan.planDurationDays)
            view.updatePlanInfo(with: [durationText, wakeUpText, toSleepText, syncText])
        }
        
        view.updateUI(doesPlanExist: plan != nil)
        view.updateStackViewButtons(doesPlanExist: plan != nil)
    }
}
