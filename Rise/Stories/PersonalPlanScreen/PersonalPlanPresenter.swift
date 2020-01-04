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
    
    private let requestPersonalPlanUseCase: RequestPersonalPlanUseCase = sharedUseCaseManager
    private let receivePersonalPlanUpdates: ReceivePersonalPlanUpdatesUseCase = sharedUseCaseManager
    
    private var personalPlan: PersonalPlan? {
        let result = requestPersonalPlanUseCase.request()
        if case .success (let plan) = result { return plan }
        return nil
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
    
    required init(view: PersonalPlanViewInput) { self.view = view }
    
    // MARK: - PersonalPlanViewOutput -
    func viewDidLoad() {
        self.updateView(with: personalPlan)
        receivePersonalPlanUpdates.receive { [weak self] personalPlan in
            self?.updateView(with: personalPlan)
        }
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
