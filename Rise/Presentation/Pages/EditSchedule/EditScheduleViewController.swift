//
//  EditScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03.01.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer
import UILibrary

extension EditSchedule {

  final class Controller:
    UIViewController,
    ViewController,
    UITableViewDelegate,
    AlertCreatable,
    AlertPresentable
  {
    enum OutCommand {
      case finish
    }

    typealias Deps = HasDeleteSchedule & HasUpdateSchedule
    typealias View = EditSchedule.View
    typealias Params = Schedule

    private let deps: Deps
    private let schedule: Schedule
    private let out: Out

    private var pickedToBed: Date?
    private var pickedSleepDuration: Int? {
      didSet {
        if let pickedSleepDuration = pickedSleepDuration {
          sleepDurationObserver?(pickedSleepDuration)
        }
      }
    }
    private var pickedIntensity: Schedule.Intensity?

    private var sleepDurationObserver: ((Int) -> Void)?

    private lazy var tableDataSource: TableDataSource = {
      let plannedToBed = schedule.targetToBed
      let minimumDurationMin: Float = 6 * 60
      let maximumDurationMin: Float = 10 * 60
      let plannedDurationMin: Float = Float(schedule.sleepDuration)
      let sleepDurationString = schedule.sleepDuration.HHmmString

      return TableDataSource(
        items: [
          [TableView.SliderCellConfigurator(model: .init(
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
          [TableView.SegmentedControlCellConfigurator(model: .init(
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
          [TableView.DatePickerCellConfigurator(
            model: .init(
              initialValue: plannedToBed,
              initialSleepDuration: schedule.sleepDuration,
              text: "Bedtime",
              datePickerDelegate: { [weak self] value in
                self?.pickedToBed = value
              },
              sleepDurationObserver: { [weak self] observer in
                self?.sleepDurationObserver = observer
              }
            )
          )],
          [TableView.ButtonCellConfigurator(model: .init(
            title: "Delete and stop",
            action: { [unowned self] in
              presentAreYouSureAlert(
                text: "You are about to delete the schedule. You can't undo this action",
                action: .init(
                  title: "Delete",
                  style: .destructive,
                  handler: { [self] _ in
                    deps.deleteSchedule()
                    out(.finish)
                  }
                )
              )
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

    init(deps: Deps, params: Params, out: @escaping Out) {
      self.deps = deps
      self.schedule = params
      self.out = out
      super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("This class does not support NSCoder")
    }

    override func loadView() {
      super.loadView()
      self.view = View(
        dataSource: tableDataSource,
        delegate: self,
        closeHandler: { [unowned self] in
          out(.finish)
        },
        saveHandler: { [unowned self] in
          guard pickedSleepDuration != nil
                  || pickedToBed != nil
                  || pickedIntensity != nil else {
            out(.finish)
            return
          }
          deps.updateSchedule(
            current: schedule,
            newSleepDuration: pickedSleepDuration,
            newToBed: pickedToBed,
            newIntensity: pickedIntensity
          )
          out(.finish)
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
  }
}

fileprivate extension EditSchedule.TableView {
  typealias DatePickerCellConfigurator
  = TableCellConfigurator<EditScheduleDatePickerTableCell, EditScheduleDatePickerTableCell.Model>
  typealias SliderCellConfigurator
  = TableCellConfigurator<EditScheduleSliderTableCell, EditScheduleSliderTableCell.Model>
  typealias ButtonCellConfigurator
  = TableCellConfigurator<EditScheduleButtonTableCell, EditScheduleButtonTableCell.Model>
  typealias SegmentedControlCellConfigurator
  = TableCellConfigurator<SegmentedControlCell, SegmentedControlCell.Model>
}
