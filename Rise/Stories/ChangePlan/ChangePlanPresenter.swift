//
//  ChangePlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate typealias DatePickerCellConfigurator = TableCellConfigurator<ChangePlanDatePickerTableCell, ChangePlanDatePickerTableCellModel>
fileprivate typealias SliderCellConfigurator = TableCellConfigurator<ChangePlanSliderTableCell, ChangePlanSliderTableCellModel>
fileprivate typealias ButtonCellConfigurator = TableCellConfigurator<ChangePlanButtonTableCell, ChangePlanButtonTableCellModel>

final class ChangePlanPresenter: ChangePlanViewOutput {
    private weak var view: ChangePlanViewInput?
    
    private var tableDataSource: TableDataSource!
    private var cellConfigurators: [[CellConfigurator]] {
        get { tableDataSource?.items ?? [] }
        set { tableDataSource?.items = newValue }
    }
    
    private let getPlan: GetPlan
    private let updatePlan: UpdatePlan
    private let deletePlan: DeletePlan
    
    private var pickedWakeUp: Date?
    private var pickedSleepDuration: Int?
    private var pickedPlanDuration: Int?
    
    required init(
        view: ChangePlanViewInput,
        getPlan: GetPlan,
        updatePlan: UpdatePlan,
        deletePlan: DeletePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.updatePlan = updatePlan
        self.deletePlan = deletePlan
    }
    
    func viewDidLoad() {
        guard let plan = try? getPlan.execute()
            else {
                log(.info, with: "Plan is nil - dismissing")
                view?.dismiss()
                return
        }
        
        let plannedWakeUpTime = plan.finalWakeUpTime
        
        let minimumDurationMin: Float = 6 * 60
        let maximumDurationMin: Float = 10 * 60
        let plannedDurationMin: Float = Float(Int(from: plan.sleepDurationSec))
        
        let sleepDurationString = plan.sleepDurationSec.HHmmString
        
        let plannedPlanDuration = plan.dateInterval.durationDays
        let minimunPlanDuration: Float = 15
        let maximumPlanDuration: Float = 45
        
        let planDurationString = "\(plannedPlanDuration.description) days"
        
        tableDataSource = TableDataSource(items: [
            [DatePickerCellConfigurator(model: ChangePlanDatePickerTableCellModel(
                initialValue: plannedWakeUpTime,
                text: "Wake up time",
                datePickerDelegate: datePickerCellDelegate(picked:))
            )],
            [SliderCellConfigurator(model: ChangePlanSliderTableCellModel(
                title: "Sleep duration",
                text: (left: "6", center: sleepDurationString, right: "10"),
                sliderMinValue: minimumDurationMin,
                sliderValue: plannedDurationMin,
                sliderMaxValue: maximumDurationMin,
                centerLabelDataSource: sliderCellCenterLabelDataSource(_:for:))
            )],
            [SliderCellConfigurator(model: ChangePlanSliderTableCellModel(
                title: "Plan duration",
                text: (left: "15", center: planDurationString, right: "45"),
                sliderMinValue: minimunPlanDuration,
                sliderValue: Float(plannedPlanDuration),
                sliderMaxValue: maximumPlanDuration,
                centerLabelDataSource: sliderCellCenterLabelDataSource(_:for:))
            )],
            [ButtonCellConfigurator(model: ChangePlanButtonTableCellModel(
                title: "Delete and stop",
                action: deletePlanPressed)
            )]
        ])
        view?.setTableView(with: tableDataSource)
        view?.reloadTable()
    }
    
    private func datePickerCellDelegate(picked value: Date) {
        pickedWakeUp = value
    }
    
    private func sliderCellCenterLabelDataSource(_ cell: ChangePlanSliderTableCell, for value: Float) -> String {
        guard let indexPath = view?.getIndexPath(of: cell)
            else {
                return ""
        }
        
        let value = Int(value)
        switch indexPath.section {
        case 1:
            pickedSleepDuration = value
            return value.HHmmString
        case 2:
            pickedPlanDuration = value
            return "\(value.description) days"
        default:
            return ""
        }
    }
    
    private func deletePlanPressed() {
        do {
         try deletePlan.execute()
        } catch {
            // handle error
        }
        close()
    }
    
    // MARK: - ChangePlanViewOutput -
    func save() {
        do {
            try updatePlan.execute(wakeUpTime: pickedWakeUp,
                                   sleepDurationMin: pickedSleepDuration,
                                   planDurationDays: pickedPlanDuration)
            print("success")
        } catch (let error) {
            print(error)
            print(error.localizedDescription)
            // todo handle error
        }
        
        close()
    }
    
    func close() {
        view?.dismiss()
    }
}
