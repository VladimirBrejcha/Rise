//
//  ChangePlanViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ChangePlanViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private var changePlanView: ChangePlanView!
    
    private typealias DatePickerCellConfigurator
        = TableCellConfigurator<ChangePlanDatePickerTableCell, ChangePlanDatePickerTableCellModel>
    private typealias SliderCellConfigurator
        = TableCellConfigurator<ChangePlanSliderTableCell, ChangePlanSliderTableCellModel>
    private typealias ButtonCellConfigurator
        = TableCellConfigurator<ChangePlanButtonTableCell, ChangePlanButtonTableCellModel>
    
    var getPlan: GetPlan! // DI
    var updatePlan: UpdatePlan! // DI
    var deletePlan: DeletePlan! // DI
    
    private var tableDataSource: TableDataSource! // late init
    private var cellConfigurators: [[CellConfigurator]] {
        get { tableDataSource?.items ?? [] }
        set { tableDataSource?.items = newValue }
    }
    
    private var pickedWakeUp: Date?
    private var pickedSleepDuration: Int?
    private var pickedPlanDuration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let plan = try? getPlan()
            else {
            log(.info, "Plan is nil - dismissing")
                dismiss()
                return
        }
        
        let plannedWakeUpTime = plan.finalWakeUpTime
        
        let minimumDurationMin: Float = 6 * 60
        let maximumDurationMin: Float = 10 * 60
        let plannedDurationMin: Float = Float(plan.sleepDurationSec.toMinutes())
        
        let sleepDurationString = plan.sleepDurationSec.HHmmString
        
        let plannedPlanDuration = plan.dateInterval.durationDays
        let minimunPlanDuration: Float = 15
        let maximumPlanDuration: Float = 45
        
        let planDurationString = "\(plannedPlanDuration.description) days"
        
        tableDataSource = TableDataSource(
            items: [
                [DatePickerCellConfigurator(model: ChangePlanDatePickerTableCellModel(
                    initialValue: plannedWakeUpTime,
                    text: "Wake up time",
                    datePickerDelegate: { [weak self] value in
                        self?.pickedWakeUp = value
                    }
                ))],
                [SliderCellConfigurator(model: ChangePlanSliderTableCellModel(
                    title: "Sleep duration",
                    text: (left: "6", center: sleepDurationString, right: "10"),
                    sliderMinValue: minimumDurationMin,
                    sliderValue: plannedDurationMin,
                    sliderMaxValue: maximumDurationMin,
                    centerLabelDataSource: { [weak self] cell, value in
                        self?.pickedSleepDuration = Int(value)
                        return Int(value).HHmmString
                    }
                ))],
                [SliderCellConfigurator(model: ChangePlanSliderTableCellModel(
                    title: "Plan duration",
                    text: (left: "15", center: planDurationString, right: "45"),
                    sliderMinValue: minimunPlanDuration,
                    sliderValue: Float(plannedPlanDuration),
                    sliderMaxValue: maximumPlanDuration,
                    centerLabelDataSource: { [weak self] cell, value in
                        self?.pickedPlanDuration = Int(value)
                        return "\(Int(value).description) days"
                    }
                ))],
                [ButtonCellConfigurator(model: ChangePlanButtonTableCellModel(
                    title: "Delete and stop",
                    action: { [weak self] in
                        do {
                            try self?.deletePlan()
                        } catch {
                            // handle error
                        }
                        self?.dismiss()
                    }
                ))]
            ]
        )
        
        changePlanView.configure(
            dataSource: tableDataSource,
            delegate: self,
            handlers: ChangePlanView.Handlers(
                close: { [weak self] in
                    self?.dismiss()
                },
                save: { [weak self] in
                    guard let self = self else { return }
                    do {
                        try self.updatePlan(
                            wakeUpTime: self.pickedWakeUp,
                            sleepDurationMin: self.pickedSleepDuration,
                            planDurationDays: self.pickedPlanDuration
                        )
                        print("success")
                    } catch (let error) {
                        print(error)
                        print(error.localizedDescription)
                        // todo handle error
                    }
                    self.dismiss()
                }
            )
        )
    }
    
    // MARK: - UITableViewDelegate -
    private let cellSpacing: CGFloat = 10
    private let sectionFooter: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 180
        case 3: return 60
        default: return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1
            ? 0
            : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sectionFooter
    }
    
    // MARK: - Private -
    private func dismiss() {
        dismiss(animated: true)
    }
}
