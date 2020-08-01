//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import LoadingView

protocol PersonalPlanViewInput: AnyObject {
    func present(controller: UIViewController)
    
    func setTableView(dataSource: UITableViewDataSource)
    func reloadTable()
    
//    func showLoading()
    func showLoadingInfo(with text: String)
    func showContent()
    
    func setLeftButton(with text: String)
    func setRightButton(with text: String, and color: UIColor)
    func showRightButton(_ show: Bool)
}

protocol PersonalPlanViewOutput: ViewControllerLifeCycle {
    func planPressed()
    func pausePressed()
}

final class PersonalPlanViewController:
    UIViewController,
    UITableViewDelegate,
    PersonalPlanViewInput,
    PropertyAnimatable
{
    var output: PersonalPlanViewOutput!
    
    @IBOutlet private weak var planManageButtonsStackView: UIStackView!
    @IBOutlet private var pauseButton: Button!
    @IBOutlet private weak var planButton: UIButton!
    @IBOutlet private weak var infomationLabel: UILabel!
    @IBOutlet private weak var tableView: PersonalPlanTableView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    var propertyAnimationDuration: Double = 0.3
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        output.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        output.viewWillDisappear()
    }
    
    @IBAction private func planTouchUp(_ sender: Button) {
        output.planPressed()
    }
    
    @IBAction private func pauseTouchUp(_ sender: Button) {
        output.pausePressed()
    }
    
    // MARK: - PersonalPlanViewInput -
    func present(controller: UIViewController) {
         Presenter.present(controller: controller, with: .modal, presentingController: self)
    }
    
    func setTableView(dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showLoadingInfo(with text: String) {
        animate {
            self.tableView.alpha = 0
            self.loadingView.state = .info(message: text)
        }
    }
    
    func showContent() {
        animate {
            self.loadingView.state = .hidden
            self.tableView.alpha = 1
        }
    }
    
    func showRightButton(_ show: Bool) {
        pauseButton.isHidden = !show
    }
    
    func setRightButton(with text: String, and color: UIColor) {
        pauseButton.setTitle(text, for: .normal)
        pauseButton.setTitleColor(color, for: .normal)
    }
    
    func setLeftButton(with text: String) {
        planButton.setTitle(text, for: .normal)
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        indexPath.section == 0
            ? tableView.frame.size.height / 4.5
            : (tableView.frame.size.height - (tableView.frame.size.height / 4.5)) / 4
    }
}
