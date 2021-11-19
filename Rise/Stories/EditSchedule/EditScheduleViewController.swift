//
//  EditScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleViewController:
    UIViewController,
    UITableViewDelegate
{

    private let schedule: Schedule
    private let updateSchedule: UpdateSchedule
    private let deleteSchedule: DeleteSchedule

    private var pickedToBed: Date?
    private var pickedSleepDuration: Schedule.Minute?
    private var pickedIntensity: Schedule.Intensity?
    
    private lazy var tableDataSource: TableDataSource = {
        let plannedToBed = schedule.targetToBed
        let minimumDurationMin: Float = 6 * 60
        let maximumDurationMin: Float = 10 * 60
        let plannedDurationMin: Float = Float(schedule.sleepDuration)
        let sleepDurationString = schedule.sleepDuration.HHmmString

        return TableDataSource(
            items: [
                [SliderCellConfigurator(model: .init(
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
                [SegmentedControlCellConfigurator(model: .init(
                    title: "Intensity",
                    selectedSegment: schedule.intensity.index,
                    segments: [
                        .init(
                            title: Schedule.Intensity.low.description,
                            handler: { [weak self] _ in
                                self?.pickedIntensity = .low
                            }
                        ),
                        .init(
                            title: Schedule.Intensity.normal.description,
                            handler: { [weak self] _ in
                                self?.pickedIntensity = .normal
                            }
                        ),
                        .init(
                            title: Schedule.Intensity.high.description,
                            handler: { [weak self] _ in
                                self?.pickedIntensity = .high
                            }
                        )
                    ]
                ))],
                [DatePickerCellConfigurator(model: .init(
                    initialValue: plannedToBed,
                    text: "To bed time",
                    datePickerDelegate: { [weak self] value in
                        self?.pickedToBed = value
                    }
                ))],
                [ButtonCellConfigurator(model: .init(
                    title: "Delete and stop",
                    action: { [weak self] in
                        self?.deleteSchedule()
                        self?.dismiss()
                    }
                ))]
            ]
        )
    }()

    private var cellConfigurators: [[CellConfigurator]] {
        get { tableDataSource.items }
        set { tableDataSource.items = newValue }
    }

    // MARK: - LifeCycle

    init(updateSchedule: UpdateSchedule,
         deleteSchedule: DeleteSchedule,
         schedule: Schedule
    ) {
        self.updateSchedule = updateSchedule
        self.deleteSchedule = deleteSchedule
        self.schedule = schedule
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        super.loadView()
        self.view = EditScheduleView(
            dataSource: tableDataSource,
            delegate: self,
            closeHandler: { [weak self] in
                self?.dismiss()
            },
            saveHandler: { [weak self] in
                guard let self = self else { return }
                guard self.pickedSleepDuration != nil
                        || self.pickedToBed != nil
                        || self.pickedIntensity != nil
                else {
                    self.dismiss()
                    return
                }
                self.updateSchedule(
                    current: self.schedule,
                    newSleepDuration: self.pickedSleepDuration,
                    newToBed: self.pickedToBed,
                    newIntensity: self.pickedIntensity
                )
                self.dismiss()
            }
        )
    }
    
    // MARK: - UITableViewDelegate -

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableDataSource.items[indexPath.section][indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        section == tableView.numberOfSections - 1
            ? 0
            : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    // MARK: - Private -

    private func dismiss() {
        dismiss(animated: true)
    }
}

fileprivate extension EditScheduleViewController {
    typealias DatePickerCellConfigurator
    = TableCellConfigurator<EditScheduleDatePickerTableCell, EditScheduleDatePickerTableCell.Model>
    typealias SliderCellConfigurator
    = TableCellConfigurator<EditScheduleSliderTableCell, EditScheduleSliderTableCell.Model>
    typealias ButtonCellConfigurator
    = TableCellConfigurator<EditScheduleButtonTableCell, EditScheduleButtonTableCell.Model>
    typealias SegmentedControlCellConfigurator
    = TableCellConfigurator<EditScheduleSegmentedControlTableCell, EditScheduleSegmentedControlTableCell.Model>
}
