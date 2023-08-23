//
//  SchedulePageViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core
import DomainLayer
import UILibrary

extension SchedulePage {

    final class Controller: UIViewController, ViewController {

        enum OutCommand {
            case createSchedule(onCreate: () -> Void)
            case editSchedule(Schedule)
        }
        typealias Deps = HasGetSchedule & HasPauseSchedule
        typealias View = SchedulePage.View

        private let getSchedule: GetSchedule
        private let pauseSchedule: PauseSchedule
        private let out: Out

        override var tabBarItem: UITabBarItem! {
            get { _tabBarItem }
            set { _tabBarItem = newValue }
        }

        private lazy var _tabBarItem: UITabBarItem = .withSystemIcons(
            normal: "person",
            selected: "person.fill"
        )

        private let bedImage = UIImage(systemName: "moon.circle.fill")
        private let sunImage = UIImage(systemName: "sunrise.circle.fill")
        private let moonImage = UIImage(systemName: "bed.double.circle.fill")

        private var schedule: Schedule? {
            getSchedule.today()
        }

        // MARK: - LifeCycle -

        init(deps: Deps, out: @escaping Out) {
            self.getSchedule = deps.getSchedule
            self.pauseSchedule = deps.pauseSchedule
            self.out = out
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("This class does not support NSCoder")
        }

        override func loadView() {
            super.loadView()
            self.view = View()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            refresh()
        }

        private var editAction: UIAction {
            UIAction(title: "Edit",
                     image: UIImage(systemName: "pencil"),
                     handler: { [weak self] _ in
                guard let schedule = self?.schedule else { return }
                self?.out(.editSchedule(schedule))
            })
        }

        private func refresh() {
            guard let schedule = schedule else {
                rootView.setState(
                    View.State(
                        showCells: .no(reason: "You don't have the schedule yet"),
                        middleButtonTitle: "Create Rise schedule",
                        middleButtonHandler: { [weak self] in
                            self?.out(.createSchedule(onCreate: {
                                self?.refresh()
                            }))
                        }
                    )
                )
                return
            }

            let sleepDuration = schedule.sleepDuration.HHmmString
            let sleepDurationPreview = ContextPreview()
            sleepDurationPreview.setState(
                ContextPreview.State(
                    image: bedImage,
                    title: "Sleep duration goal",
                    description: "Estimated daily sleep duration is \(sleepDuration)"
                )
            )
            let sleepDurationCell = View.CellState(
                image: bedImage,
                text: "Duration: \(sleepDuration)",
                contextViewController: sleepDurationPreview,
                actions: [editAction]
            )
            let intensityPreview = ContextPreview()
            intensityPreview.setState(
                .init(
                    image: UIImage(systemName: schedule.intensity.iconName),
                    title: "Intensity",
                    description: {
                        let intensityDescription = schedule.intensity.description
                        switch schedule.intensity {
                        case .low:
                            return "\(intensityDescription):\nSmoothly and calmly reaching the target"
                        case .normal:
                            return "\(intensityDescription):\nBalanced pace to reach the goal"
                        case .high:
                            return "\(intensityDescription):\nAchieving the goal most quickly"
                        }
                    }()
                )
            )
            let intensityCell = View.CellState(
                image: UIImage(systemName: schedule.intensity.iconName),
                text: "Intensity: \(schedule.intensity.description)",
                contextViewController: intensityPreview,
                actions: [editAction]
            )

            let wakeUpTime = schedule.targetWakeUp.HHmmString
            let wakeUpTimePreview = ContextPreview()
            wakeUpTimePreview.setState(
                ContextPreview.State(
                    image: sunImage,
                    title: "Wake up time goal",
                    description: "Estimated daily wake up at \(wakeUpTime) o'clock"
                )
            )
            let wakeUpCell = View.CellState(
                image: sunImage,
                text: "Wake up: \(wakeUpTime)",
                contextViewController: wakeUpTimePreview,
                actions: [editAction]
            )

            let bedtime = schedule.targetToBed.HHmmString
            let bedtimePreview = ContextPreview()
            bedtimePreview.setState(
                ContextPreview.State(
                    image: moonImage,
                    title: "Bedtime goal",
                    description: "Estimated daily bedtime at \(bedtime) o'clock"
                )
            )
            let bedtimeCell = View.CellState(
                image: moonImage,
                text: "Bedtime: \(bedtime)",
                contextViewController: bedtimePreview,
                actions: [editAction]
            )

            rootView.setState(
                View.State(
                    showCells: .yes(sleepDurationCell, intensityCell, wakeUpCell, bedtimeCell),
                    middleButtonTitle: pauseSchedule.isOnPause ? "Resume" : "Pause",
                    middleButtonHandler: { [weak self] in
                        guard let self = self, let state = self.rootView.state else { return }
                        self.pauseSchedule(!self.pauseSchedule.isOnPause)
                        self.rootView.setState(
                            state.changing {
                                $0.middleButtonTitle = self.pauseSchedule.isOnPause ? "Resume" : "Pause"
                            }
                        )
                    }
                )
            )
        }
    }
}
