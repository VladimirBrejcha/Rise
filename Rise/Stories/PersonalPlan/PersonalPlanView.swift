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
        
    struct State {
        let pauseButtonHidden: Bool
        let loadingViewState: LoadingViewState
        let tableViewAlpha: CGFloat
    }
    var state: State = State(pauseButtonHidden: true, loadingViewState: .loading, tableViewAlpha: 0) {
        didSet {
            pauseButton.isHidden = state.pauseButtonHidden
            animate {
                self.loadingView.state = self.state.loadingViewState
                self.tableView.alpha = self.state.tableViewAlpha
            }
        }
    }
    
    struct Model {
        let planButtonTitle: String
        let pauseButtonTitle: String
        let pauseButtonTitleColor: UIColor
    }
    var model: Model = Model(planButtonTitle: "", pauseButtonTitle: "", pauseButtonTitleColor: .clear) {
        didSet {
            pauseButton.setTitle(model.pauseButtonTitle, for: .normal)
            pauseButton.setTitleColor(model.pauseButtonTitleColor, for: .normal)
            planButton.setTitle(model.planButtonTitle, for: .normal)
        }
    }
    
    struct Handlers {
        let planTouch: () -> Void
        let pauseTouch: () -> Void
    }
    var handlers: Handlers?
    
    func configure(model: Model, handlers: Handlers,
                   dataSource: UITableViewDataSource, delegate: UITableViewDelegate
    ) {
        self.model = model
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        self.handlers = handlers
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    @IBAction private func planTouchUp(_ sender: Button) {
        handlers?.planTouch()
    }
    
    @IBAction private func pauseTouchUp(_ sender: Button) {
        handlers?.pauseTouch()
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
            pauseButtonTitleColor: copy.pauseButtonTitleColor
        )
    }
}
