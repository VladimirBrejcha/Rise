//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

protocol PersonalPlanDelegate: class {
    func newPlanCreated(plan: CalculatedPlan)
}

final class SetupPlanTableViewController: UITableViewController {
    
    // MARK: Properties
    private var previouslySelectedCell: ExpandingCell?
    private var gradientManager: GradientManager? {
        return GradientManager(frame: view.bounds)
    }
    private var personalTimeModel: PersonalTimeModel?
    private lazy var transitionManager = TransitionManager()
    private var wakeUpForModel: String?
    private var sleepDurationForModel: String?
    private var lastTimeWentSleepForModel: String?
    private var planDurationForModel: String?
    private var bannerManager: BannerManager? {
        return BannerManager(title: "Saved", style: .success)
    }
    weak var delegate: PersonalPlanDelegate?
    fileprivate let identifier = "expandingCell"
    
    // MARK: IBOutlets
    @IBOutlet weak var createScheduleButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ExpandingCell", bundle: nil),
                           forCellReuseIdentifier: identifier)
        
        createBackground()
    }
    
    // MARK: UISetup Methods
    private func createBackground() {
        tableView.backgroundView = gradientManager?.createStaticGradient(colors: [#colorLiteral(red: 0.1254607141, green: 0.1326543987, blue: 0.2668849528, alpha: 1), #colorLiteral(red: 0.34746629, green: 0.1312789619, blue: 0.2091784477, alpha: 1)],
                                                                         direction: .up,
                                                                         alpha: 1)
    }
    
    // MARK: Actions
    @IBAction func scheduleTapped(_ sender: UIButton) {
        guard let plan = personalTimeModel?.plan else { fatalError() }
        transitionManager.dismiss(self)
        bannerManager?.banner.show()
        delegate?.newPlanCreated(plan: plan)
    }
    
    // MARK: TableView methods
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get the correct height if the cell is a DatePickerCell.
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        return cell.pickerHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandingCell else { return }
        if previouslySelectedCell != nil
            && cell.expanded == false
            && previouslySelectedCell!.expanded {
            previouslySelectedCell?.selectedInTableView(tableView) // telling cell to hide if other cell has been selected
        }
        
        cell.selectedInTableView(tableView)
        
        previouslySelectedCell = cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ExpandingCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        cell.tag = indexPath.section
        
        switch indexPath.section {
        case 0, 2:
            cell.leftLabel.text = "Choose time:"
            cell.createPicker(.datePicker)
            
        case 1:
            cell.leftLabel.text = "Choose hours:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.hoursArray.count,
                                                  titleForRowArray: DataForPicker.hoursArray, defaultRow: 2)
            cell.createPicker(.pickerView, model: pickerDataModel)
            
        case 3:
            cell.leftLabel.text = "Choose duration:"
            let pickerDataModel = PickerDataModel(numberOfRows: DataForPicker.daysArray.count,
                                                  titleForRowArray: DataForPicker.daysArray, defaultRow: 2)
            cell.createPicker(.pickerView, model: pickerDataModel)
            
        default:
            print("error")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        }
    }
    
}

extension SetupPlanTableViewController: ExpandingCellDelegate {
    func cellValueUpdated(newValue: String, cell: ExpandingCell) {
        switch cell.tag {
        case 0:
            wakeUpForModel = newValue
        case 1:
            sleepDurationForModel = newValue
        case 2:
            lastTimeWentSleepForModel = newValue
        case 3:
            planDurationForModel = newValue
        default:
            fatalError("cell with this tag doesnt exist")
        }
        
        guard let wakeUp = wakeUpForModel,
            let sleepDuration = sleepDurationForModel,
            let wentSleep = lastTimeWentSleepForModel,
            let planDuration = planDurationForModel else { return }
        createScheduleButton.isEnabled = true
        personalTimeModel = PersonalTimeModel(wakeUp: wakeUp,
                                              sleepDuration: sleepDuration,
                                              wentSleep: wentSleep,
                                              planDuration: planDuration)
    }
    
}
