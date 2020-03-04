//
//  PersonalPlanPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 29/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate typealias ProgressCellConfigurator = TableCellConfigurator<ProgressTableViewCell, ProgressTableCellModel>
fileprivate typealias InfoCellConfigurator = TableCellConfigurator<PlanInfoTableViewCell, PlanInfoTableCellModel>

final class PersonalPlanPresenter: PersonalPlanViewOutput {
    private weak var view: PersonalPlanViewInput?
    
    private var personalPlan: PersonalPlan? { getPlan.execute() }
    private let getPlan: GetPlan
    private let updatePlan: UpdatePlan
    private let observePlan: ObservePlan

    private var tableDataSource: TableDataSource?
    private var cellConfigurators: [[CellConfigurator]] {
        get {
            guard let dataSource = tableDataSource
                else {
                    return []
            }
            return dataSource.items
        }
        set {
            guard let dataSource = tableDataSource
                else {
                    return
            }
            dataSource.items = newValue
        }
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
        tableDataSource = TableDataSource(
            items: [
                [makeEmptyProgressCellConfigurator()],
                [makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator()]
            ]
        )
        
        view?.setTableView(dataSource: tableDataSource!)
        
        observePlan.observe { [weak self] plan in
             self?.updateView(with: plan)
        }
    }
    
    func viewDidAppear() {
        updateView(with: personalPlan)
    }
    
    func planPressed() {
        if personalPlan == nil {
            view?.present(controller: Story.createPlan.configure())
        } else {
            view?.present(controller: Story.changePlan.configure())
        }
    }
    
    func pausePressed() {
        guard let plan = personalPlan else { return }
        
        let pausedPlan = PersonalPlanHelper.pause(!plan.paused, plan: plan)
        
        if updatePlan.execute(with: pausedPlan) {
            updateView(with: pausedPlan)
        }
    }
    
    // MARK: - Private -
    private func updateView(with plan: PersonalPlan?) {
        guard let view = view else { return }
        
        if let plan = plan {            
            let durationText = "\(PersonalPlanHelper.StringRepresentation.getSleepDuration(for: plan)) of sleep daily"
            let wakeUpText = "Will wake up at \(PersonalPlanHelper.StringRepresentation.getWakeTime(for: plan))"
            let toSleepText = "Will sleep at \(PersonalPlanHelper.StringRepresentation.getFallAsleepTime(for: plan))"
            //            let syncText = "Synchronized with sunrise"
            let syncText = "Coming soon"
            let planDuration = PersonalPlanHelper.StringRepresentation.getPlanDuration(for: plan)
            let progress = PersonalPlanHelper.getProgress(for: plan)
            let cellModel = ProgressTableCellModel(text: (left: "0", center: "Progress", right: planDuration), progress: progress)
            
            cellConfigurators = [
                    [ProgressCellConfigurator(model: cellModel)],
                    [InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "time", text: durationText)),
                    InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "wakeup", text: wakeUpText)),
                    InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "fallasleep", text: toSleepText)),
                    InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "sun", text: syncText))]
                ]
            
            view.reloadTable()
            view.showContent()
            view.showRightButton(true)
            view.setRightButton(with: plan.paused ? "Resume" : "Pause",
                                and: plan.paused ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 0.9143119454, green: 0.3760060668, blue: 0.4745617509, alpha: 1))
        } else {
            view.showLoadingInfo(with: "You don't have sleep plan yet, go and create one!")
            view.showRightButton(false)
            view.setLeftButton(with: "Create Rise plan")
        }
    }
    
    private func makeEmptyInfoCellConfigurator() -> CellConfigurator {
        InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "", text: ""))
    }
    
    private func makeEmptyProgressCellConfigurator() -> CellConfigurator {
        ProgressCellConfigurator(model: ProgressTableCellModel(text: (left: "", center: "", right: ""), progress: nil))
    }
}
