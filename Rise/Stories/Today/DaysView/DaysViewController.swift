//
//  DaysViewController.swift
//  Rise
//
//  Created by Владимир Королев on 07.03.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysViewController: UIViewController, Statefull {
    private typealias Snapshot = DaysView.Snapshot
    private typealias Item = DaysCollectionView.Item.Model

    private let daysView: DaysView

    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    private let getDailyTime: GetDailyTime

    init(getSunTime: GetSunTime,
         getPlan: GetPlan,
         observePlan: ObservePlan,
         getDailyTime: GetDailyTime,
         frame: CGRect
    ) {
        self.getSunTime = getSunTime
        self.getPlan = getPlan
        self.observePlan = observePlan
        self.getDailyTime = getDailyTime
        self.daysView = DaysView(frame: frame)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not meant to be called")
    }

    // MARK: - Statefull -
    struct State: Equatable {
        let sunTime: LoadState<[SunTime]>
        let plan: LoadState<RisePlan>

        enum LoadState<Data: Equatable>: Equatable {
            case loading
            case loaded (data: Data)
            case failed (error: String)
            case noData
        }
    }

    private(set) var state: State?

    func setState(_ state: State) {
        if let currentState = self.state, currentState == state {
            log(.info, "Skipping equal state \(state)")
            return
        }
        guard let currentSnapshot = daysView.snapshot else {
            log(.error, "Skipping state \(state) because currentSnapshot is nil")
            return
        }

        self.state = state

        var snapshot = Snapshot()
        snapshot.appendSections([.sun, .plan])
        let sunItems = makeItems(with: state.sunTime, snapshot: currentSnapshot)
        snapshot.appendItems(sunItems, toSection: .sun)
        let planItems = makeItems(with: state.plan, snapshot: currentSnapshot)
        snapshot.appendItems(planItems, toSection: .plan)

        daysView.applySnapshot(snapshot)
    }

    // MARK: - LifeCycle -
    override func loadView() {
        self.view = daysView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        daysView.configure(cellProvider: { collection, indexPath, item in
            if let cell = collection.dequeueReusableCell(
                withReuseIdentifier: String(describing: DaysCollectionView.Item.self),
                for: indexPath
            ) as? DaysCollectionView.Item {
                cell.configure(with: item)
                cell.repeatButtonHandler = { [weak self] cell in // todo not valid for plan cells
                    if let self = self, let state = self.state {
                        self.setState(state.changing { $0.sunTime = .loading })
                        self.refreshSunTimes()
                    }
                }
                return cell
            }
            return nil
        })

        if let plan = try? getPlan() {
            setState(State(sunTime: .loading, plan: .loaded(data: plan)))
        } else {
            setState(State(sunTime: .loading, plan: .noData))
        }
        
        daysView.centerItems()

        observePlan.observe { [weak self] plan in
            guard let self = self, let state = self.state else { return }
            if let plan = plan {
                self.setState(state.changing { $0.plan = .loaded(data: plan) })
            } else {
                self.setState(state.changing { $0.plan = .noData })
            }
        }

        refreshSunTimes()
    }

    // MARK: - Refresh sun times
    private func refreshSunTimes() {
        getSunTime(numberOfDays: 3, since: NoonedDay.yesterday.date, completionQueue: .main) { [weak self] result in
            guard let self = self, let state = self.state else { return }
            if case .success (let sunTimes) = result {
                self.setState(state.changing { $0.sunTime = .loaded(data: sunTimes) })
            }
            if case .failure = result {
                self.setState(state.changing { $0.sunTime = .failed(error: "Failed to load time") })
            }
        }
    }

    // MARK: - Make items
    private func makeItems(with state: State.LoadState<[SunTime]>, snapshot: Snapshot) -> [Item] {
        if snapshot.numberOfSections == 0 {
            return makeItems(with: state, from: defaultSunItems)
        } else {
            return makeItems(with: state, from: snapshot.itemIdentifiers(inSection: .sun))
        }
    }

    private func makeItems(with state: State.LoadState<[SunTime]>, from items: [Item]) -> [Item] {
        var result = items
        switch state {
        case .loading:
            result = items.map { $0.changing { $0.state = .loading } }
        case .loaded(let sunTimes):
            for (index, value) in sunTimes.enumerated() {
                result[index] = items[index].changing {
                    $0.state = .showingContent(left: value.sunrise.HHmmString, right: value.sunset.HHmmString)
                }
            }
        case .failed (let error):
            result = items.map { $0.changing { $0.state = .showingError(error: error) } }
        case .noData:
            result = items.map { $0.changing { $0.state = .showingInfo(info: "Time not found") } }
        }
        return result
    }

    private func makeItems(with state: State.LoadState<RisePlan>, snapshot: Snapshot) -> [Item] {
        if snapshot.numberOfSections == 0 {
            return makeItems(with: state, from: defaultPlanItems)
        } else {
            return makeItems(with: state, from: snapshot.itemIdentifiers(inSection: .plan))
        }
    }

    private func makeItems(with state: State.LoadState<RisePlan>, from items: [Item]) -> [Item] {
        var result = items
        switch state {
        case .loading:
            result = items.map { $0.changing { $0.state = .loading } }
        case .loaded(let plan):
            let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
            for (index, value) in datesArray.enumerated() {
                if let dailyTime = try? getDailyTime(for: plan, date: value.date) {
                    result[index] = items[index].changing {
                        $0.state = .showingContent(left: dailyTime.wake.HHmmString, right: dailyTime.sleep.HHmmString)
                    }
                } else {
                    result[index] = items[index].changing {
                        $0.state = .showingInfo(info: "No plan for the day")
                    }
                }
            }
        case .failed (let error):
            result = items.map { $0.changing { $0.state = .showingError(error: error) } }
        case .noData:
            result = items.map { $0.changing { $0.state = .showingInfo(info: "You don't have a plan yet") } }
        }
        return result
    }

    // MARK: - Default items
    private var defaultSunItems: [Item] {
        [.init(
            state: .loading,
            imageName: (left: "sunrise", right: "sunset"),
            id: "Sun.yesterday"
        ),
        .init(
            state: .loading,
            imageName: (left: "sunrise", right: "sunset"),
            id: "Sun.today"
        ),
        .init(
            state: .loading,
            imageName: (left: "sunrise", right: "sunset"),
            id: "Sun.tomorrow"
        )]
    }

    private var defaultPlanItems: [Item] {
        [.init(
            state: .showingInfo(info: "You don't have a plan yet"),
            imageName: (left: "wakeup", right: "bed"),
            id: "Plan.yesterday"
        ),
        .init(
            state: .showingInfo(info: "You don't have a plan yet"),
            imageName: (left: "wakeup", right: "bed"),
            id: "Plan.today"
        ),
        .init(
            state: .showingInfo(info: "You don't have a plan yet"),
            imageName: (left: "wakeup", right: "bed"),
            id: "Plan.tomorrow"
        )]
    }
}

extension DaysViewController.State: Changeable {
    init(copy: ChangeableWrapper<DaysViewController.State>) {
        self.init(sunTime: copy.sunTime, plan: copy.plan)
    }
}
