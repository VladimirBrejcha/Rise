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
    
    private var requestPersonalPlanUseCase: RequestPersonalPlanUseCase = sharedUseCaseManager
    
    var personalPlan: PersonalPlan? {
        get {
            let result = requestPersonalPlanUseCase.request()
            if case .success (let plan) = result { return plan }
            return nil
        }
    }
    
    var sleepDurationHours: Double? {
        guard let plan = personalPlan else { return nil }
        return plan.sleepDuration / 3600
    }
    
    private let dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    required init(view: PersonalPlanViewInput) { self.view = view }
    
    // MARK: - PersonalPlanViewOutput -
    func viewDidLoad() {
        view?.updateStackViewButtons(doesPlanExist: personalPlan != nil)
    }
    
    func viewDidAppear() {
        updateViewWithPlan()
    }
    
    func changeButtonPressed() {
        
    }
    
    // MARK: - Private -
    private func updateViewWithPlan() {
        guard let view = view else { return }
        
        if let plan = personalPlan {
            let durationText = "\(plan.sleepDurationHours) hours of sleep daily"
            let wakeUpText = "Will wake up at \(plan.wakeUpAt)"
            let toSleepText = "Will sleep at \(plan.willSleep)"
            let syncText = "Synchronized with sunrise"
            
            view.updateProgressView(with: plan.planProgress, maxProgress: plan.planDurationDays)
            view.updatePlanInfo(with: [durationText, wakeUpText, toSleepText, syncText])
            view.updateUI(doesPlanExist: true)
        } else {
            view.updateUI(doesPlanExist: false)
        }
    }
}
