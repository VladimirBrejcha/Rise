//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

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

protocol PersonalPlanViewOutput: ViewOutput {
    func planPressed()
    func pausePressed()
}

final class PersonalPlanViewController:
    UIViewController,
    UITableViewDelegate,
    PersonalPlanViewInput
{
    var output: PersonalPlanViewOutput!
    
    @IBOutlet private weak var planManageButtonsStackView: UIStackView!
    @IBOutlet private var pauseButton: Button!
    @IBOutlet private weak var planButton: UIButton!
    @IBOutlet private weak var infomationLabel: UILabel!
    @IBOutlet private weak var tableView: PersonalPlanTableView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.containerView.background = .clear
        tableView.delegate = self
        
        output.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        output.viewDidAppear()
    }
    
    @IBAction func planTouchUp(_ sender: Button) {
        output.planPressed()
    }
    
    @IBAction func pauseTouchUp(_ sender: Button) {
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
    
//    func showLoading() {
//        loadingView.crossDisolve(from: <#T##UIView#>, to: <#T##LoadingViewState#>)
//        showTableView(false) { self.loadingView.show(state: .showingLoading) }
//    }
    
    func showLoadingInfo(with text: String) {
        loadingView.changeState(to: .info(message: text))
    }
    
    func showContent() {
        loadingView.changeState(to: .content)
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
