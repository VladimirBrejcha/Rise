//
//  NewViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 05/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class PersonalPlanViewController: UIViewController, Statefull {
    @IBOutlet private var personalPlanView: PersonalPlanView!

    var getPlan: GetPlan! // DI
    var pausePlan: PausePlan! // DI
    var observePlan: ObservePlan! // DI

    private let bedImage = UIImage(systemName: "bed.double.fill")
    private let sunImage = UIImage(systemName: "sun.max.fill")
    private let moonImage = UIImage(systemName: "moon.fill")
    private let sparklesImage = UIImage(systemName: "sparkles")

    // MARK: - Statefull -
    struct State {
        var plan: RisePlan?
    }
    private(set) var state: State?
    func setState(_ state: State) {
        self.state = state

        if let plan = state.plan {
            let sleepDuration = plan.sleepDurationSec.HHmmString
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

            let wakeUpTime = plan.finalWakeUpTime.HHmmString
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

            let bedtime = plan.finalWakeUpTime.addingTimeInterval(-plan.sleepDurationSec).HHmmString
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
                    middleButtonTitle: plan.paused ? "Resume" : "Pause",
                    middleButtonHandler: { [weak self] in
                        try! self?.pausePlan(!plan.paused) // todo handle error
                    }
                )
            )
        } else {
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
        }
    }

    // MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        personalPlanView.configure()

        setState(State(plan: try? getPlan()))

        observePlan.observe { [weak self] plan in
            self?.setState(State(plan: plan))
        }
    }
}
