//
//  EditScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleViewController: UIViewController, UITableViewDelegate {
    @IBOutlet private var editScheduleView: EditScheduleView!
    
    private typealias DatePickerCellConfigurator
        = TableCellConfigurator<EditScheduleDatePickerTableCell, EditScheduleDatePickerTableCellModel>
    private typealias SliderCellConfigurator
        = TableCellConfigurator<EditScheduleSliderTableCell, EditScheduleSliderTableCellModel>
    private typealias ButtonCellConfigurator
        = TableCellConfigurator<EditScheduleButtonTableCell, EditScheduleButtonTableCellModel>

    var getSchedule: GetSchedule! // DI
    var updateSchedule: UpdateSchedule! // DI
    var deleteSchedule: DeleteSchedule! // DI

    private var schedule: Schedule?
    
    private var tableDataSource: TableDataSource! // late init
    private var cellConfigurators: [[CellConfigurator]] {
        get { tableDataSource?.items ?? [] }
        set { tableDataSource?.items = newValue }
    }
    
    private var pickedToBed: Date?
    private var pickedSleepDuration: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let schedule = getSchedule.today() else {
            log(.info, "Schedule is nil - dismissing")
            dismiss()
            return
        }
        self.schedule = schedule

        let plannedWakeUpTime = schedule.targetWakeUp
        
        let minimumDurationMin: Float = 6 * 60
        let maximumDurationMin: Float = 10 * 60
        let plannedDurationMin: Float = Float(schedule.sleepDuration)
        
        let sleepDurationString = schedule.sleepDuration.HHmmString
        
        tableDataSource = TableDataSource(
            items: [
                [DatePickerCellConfigurator(model: EditScheduleDatePickerTableCellModel(
                    initialValue: plannedWakeUpTime,
                    text: "To bed time",
                    datePickerDelegate: { [weak self] value in
                        self?.pickedToBed = value
                    }
                ))],
                [SliderCellConfigurator(model: EditScheduleSliderTableCellModel(
                    title: "Sleep duration",
                    text: (left: "6", center: sleepDurationString, right: "10"),
                    sliderMinValue: minimumDurationMin,
                    sliderValue: plannedDurationMin,
                    sliderMaxValue: maximumDurationMin,
                    centerLabelDataSource: { [weak self] cell, value in
                        self?.pickedSleepDuration = Int(value)
                        return Int(value).HHmmString
                    }
                ))],
                [ButtonCellConfigurator(model: EditScheduleButtonTableCellModel(
                    title: "Delete and stop",
                    action: { [weak self] in
                        self?.deleteSchedule()
                        self?.dismiss()
                    }
                ))]
            ]
        )
        
        editScheduleView.configure(
            dataSource: tableDataSource,
            delegate: self,
            handlers: EditScheduleView.Handlers(
                close: { [weak self] in
                    self?.dismiss()
                },
                save: { [weak self] in
                    guard let self = self else { return }
                    guard let schedule = self.getSchedule.today(),
                          self.pickedSleepDuration != nil || self.pickedToBed != nil
                    else {
                        self.dismiss()
                        return
                    }
                    self.updateSchedule(
                        current: schedule,
                        newSleepDuration: self.pickedSleepDuration,
                        newToBed: self.pickedToBed
                    )
                    self.dismiss()
                }
            )
        )
    }
    
    // MARK: - UITableViewDelegate -

    private let cellSpacing: CGFloat = 10
    private let sectionFooter: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 180
        case 3: return 60
        default: return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1
            ? 0
            : cellSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        sectionFooter
    }
    
    // MARK: - Private -

    private func dismiss() {
        dismiss(animated: true)
    }
}
