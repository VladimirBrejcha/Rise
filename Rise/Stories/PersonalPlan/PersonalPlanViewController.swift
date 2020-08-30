//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

final class PersonalPlanViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private var personalPlanView: PersonalPlanView!
    
    private typealias ProgressCellConfigurator = TableCellConfigurator<ProgressTableViewCell, ProgressTableCellModel>
    private typealias InfoCellConfigurator = TableCellConfigurator<PlanInfoTableViewCell, PlanInfoTableCellModel>
    
    private enum RisePlanState: Equatable {
        case planDoesntExist
        case normal(plan: RisePlan)
    }
    
    var getPlan: GetPlan! // DI
    var pausePlan: PausePlan! // DI
    var observePlan: ObservePlan! // DI
    
    private var latestUsedPlan: RisePlan?
    
    private var tableDataSource: TableDataSource!
    private var cellConfigurators: [[CellConfigurator]] {
        get {
            if let dataSource = tableDataSource {
                return dataSource.items
            } else {
                return []
            }
        }
        set {
            if let dataSource = tableDataSource {
                dataSource.items = newValue
            }
        }
    }
    
    private var viewIsVisible: Bool = false
    private var needsUpdate: Bool = true
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        latestUsedPlan = try? getPlan()
        
        tableDataSource = TableDataSource(
            items: [
                [emptyProgressCellConfigurator],
                [emptyInfoCellConfigurator,
                 emptyInfoCellConfigurator,
                 emptyInfoCellConfigurator,
                 emptyInfoCellConfigurator]
            ]
        )
        personalPlanView.configure(
            model: PersonalPlanView.Model(
                planButtonTitle: "",
                pauseButtonTitle: "",
                pauseButtonTitleColor: Color.normalTitle
            ),
            handlers: PersonalPlanView.Handlers(
                planTouch: { [weak self] in
                    guard let self = self else { return }
                    self.present(
                        self.latestUsedPlan == nil
                            ? Story.createPlan()
                            : Story.changePlan(),
                        with: .modal
                    )
                },
                pauseTouch: { [weak self] in
                    if let plan = self?.latestUsedPlan {
                        try? self?.pausePlan(!plan.paused)
                    }
                }
            ),
            dataSource: tableDataSource,
            delegate: self
        )
        
        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            self.latestUsedPlan = plan
            self.viewIsVisible
                ? self.updateView(with: plan)
                : { self.needsUpdate = true }()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if needsUpdate {
            updateView(with: latestUsedPlan)
            needsUpdate = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewIsVisible = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewIsVisible = false
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0
            ? tableView.frame.size.height / 4.5
            : (tableView.frame.size.height - (tableView.frame.size.height / 4.5)) / 4
    }
    
    // MARK: - Private -
    private func updateView(with plan: RisePlan?) {
        updateButtons(with: plan)
        updateLoadingView(with: plan)
        updateTableView(with: plan)
    }
    
    private func updateButtons(with plan: RisePlan?) {
        if let plan = plan {
            personalPlanView.state = personalPlanView.state.changing { state in
                state.pauseButtonHidden = false
            }
            personalPlanView.model = personalPlanView.model.changing { model in
                model.pauseButtonTitle = plan.paused ? "Resume" : "Pause"
                model.pauseButtonTitleColor = plan.paused ? Color.normalTitle : Color.redTitle
                model.planButtonTitle = "Change"
            }
        } else {
            personalPlanView.state = personalPlanView.state.changing { state in
                state.pauseButtonHidden = true
            }
            personalPlanView.model = personalPlanView.model.changing { model in
                model.planButtonTitle = "Create Rise plan"
            }
        }
    }
    
    private func updateLoadingView(with plan: RisePlan?) {
        if plan == nil {
            personalPlanView.state = personalPlanView.state.changing { state in
                state.loadingViewState = .info(message: "You don't have sleep plan yet, go and create one!")
                state.tableViewAlpha = 0
            }
        } else {
            personalPlanView.state = personalPlanView.state.changing { state in
                state.loadingViewState = .hidden
                state.tableViewAlpha = 1
            }
        }
    }
    
    private func updateTableView(with plan: RisePlan?) {
        if let plan = plan {
            let durationText = "\(plan.sleepDurationSec.HHmmString) of sleep daily"
            let wakeUpText = "Will wake up at \(plan.finalWakeUpTime.HHmmString)"
            let toSleepText = "Will sleep at \(plan.finalWakeUpTime.addingTimeInterval(-plan.sleepDurationSec).HHmmString)"
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
            
            personalPlanView.reloadData()
            personalPlanView.state = personalPlanView.state.changing { state in
                state.loadingViewState = .hidden
                state.tableViewAlpha = 1
            }
        }
    }
    
    private var emptyInfoCellConfigurator: CellConfigurator {
        InfoCellConfigurator(model: PlanInfoTableCellModel(imageName: "", text: ""))
    }
    
    private var emptyProgressCellConfigurator: CellConfigurator {
        ProgressCellConfigurator(model: ProgressTableCellModel(text: (left: "", center: "", right: ""), progress: nil))
    }
}
