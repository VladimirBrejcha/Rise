//
//  SetupPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PersonalPlanDelegate: class {
    func newPlanCreated(plan: CalculatedPlan)
}

class SetupPlanPresenter: SetupPlanViewOutput {    
    weak var view: SetupPlanViewInput!
    private var personalPlanModel: PersonalPlanModel?
    
    // old
    weak var personalPlanDelegate: PersonalPlanDelegate?
    private var personalTimeModel: PersonalTimeModel?
    private var wakeUpForModel: String?
    private var sleepDurationForModel: String?
    private var lastTimeWentSleepForModel: String?
    private var planDurationForModel: String?
    //
    
    init(view: SetupPlanViewInput) { self.view = view }
    
    // MARK: - SetupPlanViewOutput
    func scheduleTapped() {
        createPlan()
        view.dismiss()
        view.showBanner()
    }
    
    private func createPlan() {
        guard let plan = personalTimeModel?.plan else { fatalError() }
        personalPlanDelegate?.newPlanCreated(plan: plan)
    }
    
    // MARK: - ExpandingCellDelegate
    func cellValueUpdated(with value: String, cell: ExpandingCell) {
        switch cell.tag
        {
        case 0: wakeUpForModel = value
        case 1: sleepDurationForModel = value
        case 2: lastTimeWentSleepForModel = value
        case 3: planDurationForModel = value
        default: fatalError("cell with this tag doesnt exist")
        }
        
        guard let wakeUp = wakeUpForModel,
            let sleepDuration = sleepDurationForModel,
            let wentSleep = lastTimeWentSleepForModel,
            let planDuration = planDurationForModel else { return }
        
        view.isScheduleButtonEnabled = true
        
        personalTimeModel = PersonalTimeModel(wakeUp: wakeUp,
                                              sleepDuration: sleepDuration,
                                              wentSleep: wentSleep,
                                              planDuration: planDuration)
    }
}
