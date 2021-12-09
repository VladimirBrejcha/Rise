//
//  ScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScheduleViewController: UIViewController {

    private var loadedView: ScheduleView {
        view as! ScheduleView
    }

    private let getSchedule: GetSchedule
    private let pauseSchedule: PauseSchedule

    private let bedImage = UIImage(systemName: "bed.double.fill")
    private let sunImage = UIImage(systemName: "sun.max.fill")
    private let moonImage = UIImage(systemName: "moon.fill")
    private let speedometerImage = UIImage(systemName: "speedometer")

    private var schedule: Schedule? {
        getSchedule.today()
    }

    // MARK: - LifeCycle -

    init(getSchedule: GetSchedule, pauseSchedule: PauseSchedule) {
        self.getSchedule = getSchedule
        self.pauseSchedule = pauseSchedule
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        super.loadView()
        self.view = ScheduleView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        guard let schedule = schedule else {
            loadedView.setState(
                ScheduleView.State(
                    showCells: .no(reason: "You don't have the schedule yet"),
                    middleButtonTitle: "Create Rise schedule",
                    middleButtonHandler: { [weak self] in
                        self?.present(
                            Story.createSchedule(onCreate: { [weak self] in
                                self?.refresh()
                            })(),
                            with: .modal
                        )
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
        let sleepDurationCell = ScheduleView.CellState(
            image: bedImage,
            text: "\(sleepDuration) of sleep daily",
            contextViewController: sleepDurationPreview,
            actions: []
        )
        let intensityPreview = ContextPreview()
        intensityPreview.setState(
            .init(
                image: speedometerImage,
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
        let intensityCell = ScheduleView.CellState(
            image: speedometerImage,
            text: "\(schedule.intensity.description) intensity",
            contextViewController: intensityPreview,
            actions: []
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
        let wakeUpCell = ScheduleView.CellState(
            image: sunImage,
            text: "Wake up at \(wakeUpTime) o'clock",
            contextViewController: wakeUpTimePreview,
            actions: []
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
        let bedtimeCell = ScheduleView.CellState(
            image: moonImage,
            text: "Bedtime at \(bedtime) o'clock",
            contextViewController: bedtimePreview,
            actions: []
        )

        loadedView.setState(
            ScheduleView.State(
                showCells: .yes(sleepDurationCell, intensityCell, wakeUpCell, bedtimeCell),
                middleButtonTitle: pauseSchedule.isOnPause ? "Resume" : "Pause",
                middleButtonHandler: { [weak self] in
                    guard let self = self, let state = self.loadedView.state else { return }
                    self.pauseSchedule(!self.pauseSchedule.isOnPause)
                    self.loadedView.setState(
                        state.changing {
                            $0.middleButtonTitle = self.pauseSchedule.isOnPause ? "Resume" : "Pause"
                        }
                    )
                }
            )
        )
    }
}
