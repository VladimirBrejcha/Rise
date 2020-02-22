//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

fileprivate let infoTableViewInfo = (nib: UINib(nibName: "PlanInfoTableViewCell", bundle: nil),
                                     cellID: "infoCell")
fileprivate let progressTableViewInfo = (nib: UINib(nibName: "ProgressTableViewCell", bundle: nil),
                                         cellID: "progressCell")

protocol PersonalPlanViewInput: AnyObject {
    func present(controller: UIViewController)
    
    func updateProgressView(with progress: Double, maxProgress: String)
    func updatePlanInfo(with info: [String])
    
    func showLoading(_ show: Bool)
    
    func updateUI(doesPlanExist: Bool)
    func updateStackViewButtons(doesPlanExist: Bool)
    func updatePauseTitle(with text: String)
    func pausePerformance(_ pause: Bool)
}

protocol PersonalPlanViewOutput: ViewOutput {
    func planPressed()
    func pausePressed()
}

final class PersonalPlanViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    PersonalPlanViewInput
{
    var output: PersonalPlanViewOutput!
    
    @IBOutlet private weak var planManageButtonsStackView: UIStackView!
    @IBOutlet private var pauseButton: Button!
    @IBOutlet private weak var planButton: UIButton!
    @IBOutlet private weak var infomationLabel: UILabel!
    
    @IBOutlet private weak var infoTableView: UITableView!
    @IBOutlet private weak var progressTableView: UITableView!
    
    @IBOutlet private weak var mainContainerView: UIView!
    @IBOutlet private weak var loadingView: LoadingView!
    
    private var progressCellMaxValue: String?
    private var progressCellValue: Double = 0.0
    private let infoCellImageArray: [UIImage] = [#imageLiteral(resourceName: "Clock"), #imageLiteral(resourceName: "wakeup"), #imageLiteral(resourceName: "fallasleep"), #imageLiteral(resourceName: "sun")]
    private var infoCellLabelTextArray: [String]?
    
    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView(tableView: infoTableView, info: infoTableViewInfo)
        configureTableView(tableView: progressTableView, info: progressTableViewInfo)
        
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
    
    func updatePlanInfo(with info: [String]) {
        infoCellLabelTextArray = info
        infoTableView.reloadData()
    }
    
    func updateProgressView(with progress: Double, maxProgress: String) {
        progressCellValue = progress
        progressCellMaxValue = maxProgress
        progressTableView.reloadData()
    }
    
    func updateUI(doesPlanExist: Bool) {
        doesPlanExist
            ? hidePlanDoesntExistInfo()
            : showPlanDoesntExistInfo()
    }
    
    func updateStackViewButtons(doesPlanExist: Bool) {
        doesPlanExist
            ? { planButton.setTitle("Change", for: .normal)
                planManageButtonsStackView.addArrangedSubview(pauseButton)
                pauseButton.setTitleColor(#colorLiteral(red: 0.9143119454, green: 0.3760060668, blue: 0.4745617509, alpha: 1), for: .normal)
                }()
            : { planButton.setTitle("Create", for: .normal)
                pauseButton.removeFromSuperview() }()
    }
    
    func pausePerformance(_ pause: Bool) {
        guard let cell = progressTableView.cellForRow(at: IndexPath(row: 0, section: 0))
            as? ProgressTableViewCell
            else {
                return
        }
        cell.paused = pause
    }
    
    func showLoading(_ show: Bool) {
        show
            ? loadingView.show(state: .showingLoading)
            : loadingView.show(state: .hidden) {
                UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations:
                    { self.mainContainerView.alpha = 1 })
        }
    }
    
    func updatePauseTitle(with text: String) {
        pauseButton.setTitle(text, for: .normal)
    }
    
    // MARK: - Private -
    private func configureTableView(tableView: UITableView, info: (nib: UINib, cellID: String)) {
        tableView.register(info.nib, forCellReuseIdentifier: info.cellID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showPlanDoesntExistInfo() {
        mainContainerView.alpha = 0
        loadingView.show(state: .showingInfo(info: "You don't have sleep plan yet, go and create one!"))
    }
    
    private func hidePlanDoesntExistInfo() {
        loadingView.show(state: .hidden) {
            UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction, animations: {
                self.mainContainerView.alpha = 1
            })
        }
    }
    
    // MARK: - UITableViewDataSource -
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return tableView == progressTableView ? 1 : 4 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == progressTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: progressTableViewInfo.cellID, for: indexPath) as! ProgressTableViewCell
            cell.centerProgressLabel.text = "Perfomance"
            cell.startProgressLabel.text = "0"
            cell.endProgressLabel.text = progressCellMaxValue
            cell.progress = CGFloat(progressCellValue)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: infoTableViewInfo.cellID, for: indexPath) as! PlanInfoTableViewCell
            cell.infoImageView.image = infoCellImageArray[indexPath.row]
            cell.infoLabel.text = infoCellLabelTextArray?[indexPath.row]
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate -
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == progressTableView ? tableView.frame.size.height : tableView.frame.size.height / 4
    }
}
