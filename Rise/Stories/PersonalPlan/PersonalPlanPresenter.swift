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

fileprivate enum RisePlanState: Equatable {
    case planDoesntExist
    case normal(plan: RisePlan)
}

final class PersonalPlanPresenter: PersonalPlanViewOutput {
    private weak var view: PersonalPlanViewInput?
    
    private let getPlan: GetPlan
    private let pausePlan: PausePlan
    private let observePlan: ObservePlan
    
    private var latestUsedPlan: RisePlan?

    private var tableDataSource: TableDataSource!
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
    
    private var viewIsVisible: Bool = false
    private var needsUpdate: Bool = true
    
    required init(
        view: PersonalPlanViewInput,
        getPlan: GetPlan,
        pausePlan: PausePlan,
        observePlan: ObservePlan
    ) {
        self.view = view
        self.getPlan = getPlan
        self.pausePlan = pausePlan
        self.observePlan = observePlan
    }
    
    // MARK: - PersonalPlanViewOutput -
    func viewDidLoad() {
        latestUsedPlan = try? getPlan.execute()
        
        tableDataSource = TableDataSource(
            items: [
                [makeEmptyProgressCellConfigurator()],
                [makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator(),
                 makeEmptyInfoCellConfigurator()]
            ]
        )
        
        view?.setTableView(dataSource: tableDataSource)
        
        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            self.latestUsedPlan = plan
            self.viewIsVisible
                ? self.updateView(with: plan)
                : { self.needsUpdate = true }()
        }
    }
    
    func viewWillAppear() {
        if needsUpdate {
            updateView(with: latestUsedPlan)
            needsUpdate = false
        }
    }
    
    func viewDidAppear() {
        viewIsVisible = true
    }
    
    func viewWillDisappear() {
        viewIsVisible = false
    }
    
    func planPressed() {
        view?.present(
            controller: latestUsedPlan == nil
                ? Story.createPlan.configure()
                : Story.changePlan.configure()
        )
    }
    
    func pausePressed() {
        if let plan = latestUsedPlan {
            try? pausePlan.execute(pause: !plan.paused)
        }
    }
    
    // MARK: - Private -
    private func updateView(with plan: RisePlan?) {
        updateButtons(with: plan)
        updateLoadingView(with: plan)
        updateTableView(with: plan)
    }
    
    private func updateButtons(with plan: RisePlan?) {
        if let plan = plan {
            view?.showRightButton(true)
            view?.setRightButton(with: plan.paused ? "Resume" : "Pause",
                                 and: plan.paused ? Color.normalTitle : Color.redTitle)
            view?.setLeftButton(with: "Change")
        } else {
            view?.showRightButton(false)
            view?.setLeftButton(with: "Create Rise plan")
        }
    }
    
    private func updateLoadingView(with plan: RisePlan?) {
        plan == nil
            ? view?.showLoadingInfo(with: "You don't have sleep plan yet, go and create one!")
            : view?.showContent()
    }
    
    private func updateTableView(with plan: RisePlan?) {
        guard let view = view else { return }
        
        if let plan = plan {
            let durationText = "\(plan.sleepDurationSec.HHmmString) of sleep daily"
            let wakeUpText = "Will wake up at \(plan.finalWakeUpTime.HHmmString)"
            let toSleepText = "Will sleep at \(plan.finalWakeUpTime.addingTimeInterval(-plan.sleepDurationSec).HHmmString)"
            //            let syncText = "Synchronized with sunrise"
            let syncText = "Coming soon"
            let planDuration = plan.dateInterval.durationDays
            let completedDays = DateInterval(start: plan.dateInterval.start, end: plan.latestConfirmedDay).durationDays
            let progress = (planDuration - (planDuration - completedDays)) / planDuration
            let cellModel = ProgressTableCellModel(text: (left: "0", center: "Progress", right: "\(planDuration)"),
                                                   progress: Float(progress))
            
            cellConfigurators = [
                [ProgressCellConfigurator(model: cellModel)],
                [InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "time", text: durationText)),
                 InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "wakeup", text: wakeUpText)),
                 InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "fallasleep", text: toSleepText)),
                 InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "sun", text: syncText))]
            ]
            
            view.reloadTable()
            view.showContent()
        }
    }
    
    private func makeEmptyInfoCellConfigurator() -> CellConfigurator {
        InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "", text: ""))
    }
    
    private func makeEmptyProgressCellConfigurator() -> CellConfigurator {
        ProgressCellConfigurator(model: ProgressTableCellModel(text: (left: "", center: "", right: ""), progress: nil))
    }
}
