//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PersonalPlanViewController: UIViewController {

    @IBOutlet private var personalPlanView: PersonalPlanView!

    var getSchedule: GetSchedule! // DI
    var pauseSchedule: PauseSchedule! // DI

    private let bedImage = UIImage(systemName: "bed.double.fill")
    private let sunImage = UIImage(systemName: "sun.max.fill")
    private let moonImage = UIImage(systemName: "moon.fill")
    private let sparklesImage = UIImage(systemName: "sparkles")

    private var schedule: Schedule?

    // MARK: - LifeCycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        personalPlanView.configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }

    private func refresh() {
        schedule = getSchedule.today()

        guard let schedule = schedule else {
            personalPlanView.setState(
                PersonalPlanView.State(
                    showCells: .no(reason: "You don't have the plan yet"),
                    title: "Personal plan",
                    middleButtonTitle: "Create Rise plan",
                    middleButtonHandler: { [weak self] in
                        self?.present(Story.createPlan(), with: .modal)
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
        let sleepDurationCell = PersonalPlanView.CellState(
            image: bedImage,
            text: "\(sleepDuration) of sleep daily",
            contextViewController: sleepDurationPreview,
            actions: []
        )

        let sunSyncCell = PersonalPlanView.CellState(
            image: sparklesImage,
            text: "Coming soon",
            contextViewController: nil,
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
        let wakeUpCell = PersonalPlanView.CellState(
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
        let bedtimeCell = PersonalPlanView.CellState(
            image: moonImage,
            text: "Bedtime at \(bedtime) o'clock",
            contextViewController: bedtimePreview,
            actions: []
        )

        personalPlanView.setState(
            PersonalPlanView.State(
                showCells: .yes(sleepDurationCell, sunSyncCell, wakeUpCell, bedtimeCell),
                title: "Personal plan",
                middleButtonTitle: pauseSchedule.isOnPause ? "Resume" : "Pause",
                middleButtonHandler: { [weak self] in
                    guard let self = self else { return }
                    self.pauseSchedule(!self.pauseSchedule.isOnPause)
                }
            )
        )
    }
}
