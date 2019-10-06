//
//  SetupPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct DataForPicker {
    static let daysArray = ["Hardcore - 10 days", "Normal - 15 days", "Recommended - 30 days", "Calm - 50 days"]
    static let hoursArray = ["7 hours", "7.5 hours", "Recommended - 8 hours", "8.5 hours", "9 hours"]
    
    private init() { }
}

protocol PersonalPlanDelegate: class {
    func newPlanCreated(_ plan: PersonalPlanModel)
}

fileprivate let daysArray = ["Hardcore - 10 days", "Normal - 15 days", "Recommended - 30 days", "Calm - 50 days"]
fileprivate let hoursArray = ["7 hours", "7.5 hours", "Recommended - 8 hours", "8.5 hours", "9 hours"]

class SetupPlanPresenter: SetupPlanViewOutput {
    weak var view: SetupPlanViewInput!
    
    weak var personalPlanDelegate: PersonalPlanDelegate?
    
    var dataSource: SectionedTableViewDataSource?
    
    private var personalPlanModel: PersonalPlanModel?
    private var wakeUpForModel: Date?
    private var sleepDurationForModel: String?
    private var lastTimeWentSleepForModel: Date?
    private var planDurationForModel: String?
    
    init(view: SetupPlanViewInput) { self.view = view }
    
    // MARK: - SetupPlanViewOutput
    func viewDidLoad() {
        let datePickerModel = PickerDataModel(tag: 0, labelText: "Choose time", type: .datePicker)
        let hoursPickerModel = PickerDataModel(tag: 1, labelText: "Choose hours", type: .pickerView, titleForRowArray: hoursArray, defaultRow: 2)
        let secondDatePickerModel = PickerDataModel(tag: 2, labelText: "Choose time", type: .datePicker)
        let durationPickerModel = PickerDataModel(tag: 3, labelText: "Choose duration", type: .pickerView, titleForRowArray: daysArray, defaultRow: 2)
        
        dataSource = SectionedTableViewDataSource(dataSources:
            [TableViewDataSource.make(for: [datePickerModel], reuseIdentifier: view.cellID, output: self),
             TableViewDataSource.make(for: [hoursPickerModel], reuseIdentifier: view.cellID, output: self),
             TableViewDataSource.make(for: [secondDatePickerModel], reuseIdentifier: view.cellID, output: self),
             TableViewDataSource.make(for: [durationPickerModel], reuseIdentifier: view.cellID, output: self)])
        view.setupPlanTableView?.dataSource = dataSource
    }
    
    func scheduleTapped() {
        createPlan()
        view?.showBanner()
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
        print("worked")
        view?.isScheduleButtonEnabled = true
        
        personalPlanModel = PersonalPlanBuilder.buildPlan(wakeUp: wakeUp, wentSleep: wentSleep, sleepDuration: sleepDuration, planDuration: planDuration)
    }
}
