//
//  PersonalPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

class PersonalPlanPresenter: PersonalPlanViewOutput {
    weak var view: PersonalPlanViewInput?
    
    var personalPlanHelper: PersonalPlanHelper?
    private var coreDataManager: CoreDataManager! { return sharedCoreDataManager }
    
    init(view: PersonalPlanViewInput) { self.view = view }
    
    // MARK: - PersonalPlanViewOutput
    func viewDidLoad() {

    }
    
    func viewDidAppear() {
        if coreDataManager.currentPlan != nil {
            
        } else {
            view?.showPlanDoesntExistInfo()
        }Rise/Stories/PersonalPlanScreen/PersonalPlanViewController.swift
    }
    
    func changeButtonPressed() {
    }
    
    // MARK: - PersonalPlanDelegate
    func newPlanCreated(_ plan: PersonalPlanModel) {
        personalPlanHelper = PersonalPlanHelper(plan: plan)
        let durationText = "\(personalPlanHelper!.sleepDurationHours) hours of sleep daily"
        let wakeUpText = "Will wake up at \(personalPlanHelper!.wakeUpAt)"
        let toSleepText = "Will sleep at \(personalPlanHelper!.willSleep)"
        let syncText = "Synchronized with sunrise"
        
        view?.updateProgressView(with: 0.7, maxProgress: personalPlanHelper!.planDurationDays.description)

        view?.updatePlanInfo(with: [durationText, wakeUpText, toSleepText, syncText])
        view?.hidePlanDoesntExistInfo()
    }
}
