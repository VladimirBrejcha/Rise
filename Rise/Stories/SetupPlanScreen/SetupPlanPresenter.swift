//
//  SetupPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol PersonalPlanDelegate: class {
    func newPlanCreated(_ plan: PersonalPlanModel)
}

class SetupPlanPresenter: SetupPlanViewOutput {
    weak var view: SetupPlanViewInput!
    
    weak var personalPlanDelegate: PersonalPlanDelegate?
    
    private var personalPlanModel: PersonalPlanModel?
    private var wakeUpForModel: Date?
    private var sleepDurationForModel: String?
    private var lastTimeWentSleepForModel: Date?
    private var planDurationForModel: String?
    
    init(view: SetupPlanViewInput) { self.view = view }
    
    // MARK: - SetupPlanViewOutput
    func scheduleTapped() {
        view.dismiss()
        createPlan()
        view.showBanner()
    }
    
    private func createPlan() { personalPlanDelegate?.newPlanCreated(personalPlanModel!)  }
    
    // MARK: - ExpandingCellDelegate
    func cellValueUpdated(with value: PickerOutputValue, cell: ExpandingCell) {
        switch cell.tag
        {
        case 0: wakeUpForModel = value.dateValue
        case 1: sleepDurationForModel = value.stringValue
        case 2: lastTimeWentSleepForModel = value.dateValue
        case 3: planDurationForModel = value.stringValue
        default: fatalError("cell with this tag doesnt exist")
        }
        
        guard let wakeUp = wakeUpForModel,
            let sleepDuration = sleepDurationForModel,
            let wentSleep = lastTimeWentSleepForModel,
            let planDuration = planDurationForModel else { return }
        
        view.isScheduleButtonEnabled = true
        
        personalPlanModel = PersonalPlanBuilder.buildPlan(wakeUp: wakeUp, wentSleep: wentSleep, sleepDuration: sleepDuration, planDuration: planDuration)
    }
}
