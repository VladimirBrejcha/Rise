//
//  PersonalTimeViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 25/05/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

final class PersonalTimeViewController: UITableViewController {
    
    // MARK: Properties
    private var previouslySelectedCell: ExpandingCell?
    private var gradientManager: GradientManager? {
        return GradientManager(frame: view.bounds)
    }
    private var personalTimeModel: PersonalTimeModel?
    private let notificationCenter: NotificationCenter = .default
    private var transitionManager: TransitionManager? {
        return TransitionManager()
    }
    private var wakeUpForModel: String?
    private var sleepDurationForModel: String?
    private var lastTimeWentSleepForModel: String?
    private var planDurationForModel: String?
    
    // MARK: IBOutlets
    @IBOutlet weak var createScheduleButton: UIButton!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Cell.nibName, bundle: nil),
                           forCellReuseIdentifier: Cell.identifier)
        
        notificationCenter.addObserver(self,
                                       selector: #selector(updateModel),
                                       name: .pickerValueChanged,
                                       object: nil)
        
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
        personalTimeModel!.buildCalculator()
        transitionManager?.dismiss(self)
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
    
    @objc func updateModel() {
        
        guard let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!) as? ExpandingCell  else { fatalError("cell wasnt find") }
        guard let pickedValue = cell.pickedValue  else { fatalError("pickedValue is nil") }
        
        switch cell.tag {
        case 0:
            wakeUpForModel = pickedValue
        case 1:
            sleepDurationForModel = pickedValue
        case 2:
            lastTimeWentSleepForModel = pickedValue
        case 3:
            planDurationForModel = pickedValue
        default:
            fatalError("cell with this tag doent exists")
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier) as? ExpandingCell else {
            return UITableViewCell()
        }
        
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
