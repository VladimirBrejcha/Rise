//
//  PersonalPlanView.swift
//  Rise
//
//  Created by Владимир Королев on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

final class PersonalPlanView: UIView, PropertyAnimatable {
    @IBOutlet private weak var planManageButtonsStackView: UIStackView!
    @IBOutlet private var pauseButton: Button!
    @IBOutlet private weak var planButton: UIButton!
    @IBOutlet private weak var infomationLabel: UILabel!
    @IBOutlet private weak var tableView: PersonalPlanTableView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double = 0.3
    
    struct Model {
        let planButtonTitle: String
        let pauseButtonTitle: String
        let pauseButtonTitleColor: UIColor
        let planTouchHandler: () -> Void
        let pauseTouchHandler: () -> Void
        let tableDataSource: UITableViewDataSource
        let tableDelegate: UITableViewDelegate
    }
    
    struct State {
        let pauseButtonHidden: Bool
        let loadingViewState: LoadingViewState
        let tableViewAlpha: CGFloat
    }
    var state: State? {
        didSet {
            if let state = state {
                pauseButton.isHidden = state.pauseButtonHidden
                animate {
                    self.loadingView.state = state.loadingViewState
                    self.tableView.alpha = state.tableViewAlpha
                }
            }
        }
    }
    
    var model: Model? {
        didSet {
            if let model = model {
                pauseButton.setTitle(model.pauseButtonTitle, for: .normal)
                pauseButton.setTitleColor(model.pauseButtonTitleColor, for: .normal)
                planButton.setTitle(model.planButtonTitle, for: .normal)
                tableView.delegate = model.tableDelegate
                tableView.dataSource = model.tableDataSource
            }
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction private func planTouchUp(_ sender: Button) {
        model?.planTouchHandler()
    }
    
    @IBAction private func pauseTouchUp(_ sender: Button) {
        model?.pauseTouchHandler()
    }
}

extension PersonalPlanView.State: Changeable {
    init(copy: ChangeableWrapper<PersonalPlanView.State>) {
        self.init(
            pauseButtonHidden: copy.pauseButtonHidden,
            loadingViewState: copy.loadingViewState,
            tableViewAlpha: copy.tableViewAlpha
        )
    }
}

extension PersonalPlanView.Model: Changeable {
    init(copy: ChangeableWrapper<PersonalPlanView.Model>) {
        self.init(
            planButtonTitle: copy.planButtonTitle,
            pauseButtonTitle: copy.pauseButtonTitle,
            pauseButtonTitleColor: copy.pauseButtonTitleColor,
            planTouchHandler: copy.planTouchHandler,
            pauseTouchHandler: copy.pauseTouchHandler,
            tableDataSource: copy.tableDataSource,
            tableDelegate: copy.tableDelegate
        )
    }
}
