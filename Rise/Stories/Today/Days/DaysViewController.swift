//
//  DaysViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 07.03.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class DaysViewController: UIViewController, Statefull {

    private typealias Snapshot = DaysCollectionView.Snapshot
    private typealias Item = DaysCollectionView.Item.Model

    var daysView: DaysView { view as! DaysView }

    private let getSunTime: GetSunTime
    private let getPlan: GetPlan
    private let observePlan: ObservePlan
    private let getDailyTime: GetDailyTime

    struct State: Equatable {
        let sunTime: LoadState<[NoonedDay: SunTime]>
        let plan: LoadState<RisePlan>

        enum LoadState<Data: Equatable>: Equatable {
            case loading
            case loaded (data: Data)
            case failed (error: String)
            case noData
        }
    }
    private(set) var state: State?

    // MARK: - LifeCycle

    init(getSunTime: GetSunTime,
         getPlan: GetPlan,
         observePlan: ObservePlan,
         getDailyTime: GetDailyTime
    ) {
        self.getSunTime = getSunTime
        self.getPlan = getPlan
        self.observePlan = observePlan
        self.getDailyTime = getDailyTime
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        self.view = DaysView(
            cellProvider: { collection, indexPath, item in
                guard let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: String(describing: DaysCollectionView.Item.self),
                    for: indexPath
                ) as? DaysCollectionView.Item else {
                    return nil
                }

                cell.configure(with: item)
                cell.repeatButtonHandler = { [weak self] id in
                    self?.repeatButtonHandler(identifier: id)
                }

                return cell
            },
            sectionTitles: [
                Text.yesterday,
                Text.today,
                Text.tomorrow
            ]
        )

        DispatchQueue.main.async { [self] in
            observePlan.observe { [weak self] plan in
                guard let self = self, let state = self.state else { return }
                if let plan = plan {
                    self.setState(state.changing { $0.plan = .loaded(data: plan) })
                } else {
                    self.setState(state.changing { $0.plan = .noData })
                }
            }

            refreshSunTimes()

            if let plan = try? getPlan() {
                setState(State(sunTime: .loading, plan: .loaded(data: plan)))
            } else {
                setState(State(sunTime: .loading, plan: .noData))
            }

            daysView.centerItems()
        }
    }
    
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
        snapshot.appendSections([.yesterday, .today, .tomorrow])
        snapshot.appendItems(
            makeItems(
                for: state,
                day: .yesterday,
                snapshot: currentSnapshot
            ),
            toSection: .yesterday
        )
        snapshot.appendItems(
            makeItems(
                for: state,
                day: .today,
                snapshot: currentSnapshot
            ),
            toSection: .today
        )
        snapshot.appendItems(
            makeItems(
                for: state,
                day: .tomorrow,
                snapshot: currentSnapshot
            ),
            toSection: .tomorrow
        )

        daysView.applySnapshot(snapshot)
    }

    // MARK: - Actions

    private func repeatButtonHandler(identifier: Item.ID) {
        log(.info, "Repeat button pressed on cell: \(identifier)")
        guard identifier.kind == .sun else { return }
        if let state = self.state {
            setState(
                state.changing {
                    $0.sunTime = .loading
                }
            )
            refreshSunTimes()
        }
    }

    // MARK: - Refresh sun times

    private func refreshSunTimes() {
        getSunTime(
            numberOfDays: 3,
            since: NoonedDay.yesterday.date,
            completionQueue: .main
        ) { [weak self] result in
            guard let self = self, let state = self.state else { return }
            if case .success (let sunTimes) = result {
                self.setState(
                    state.changing {
                        $0.sunTime = .loaded(
                            data: Dictionary(
                                uniqueKeysWithValues: zip(
                                    NoonedDay.allCases, sunTimes
                                )
                            )
                        )
                    }
                )
            }
            if case .failure = result {
                self.setState(
                    state.changing {
                        $0.sunTime = .failed(error: Text.failedToLoadTime)
                    }
                )
            }
        }
    }

    // MARK: - Make items

    private func transformItem(_ item: Item, applying state: State.LoadState<RisePlan>) -> Item {
        switch state {
        case .loading:
            return item.changing { $0.state = .loading }
        case .loaded(let plan):
            if let dailyTime = try? getDailyTime(for: plan, date: item.id.day.date) {
                return item.changing {
                    $0.state = .showingContent(
                        left: dailyTime.wake.HHmmString,
                        right: dailyTime.sleep.HHmmString
                    )
                }
            } else {
                return item.changing {
                    $0.state = .showingInfo(info: Text.noPlanForTheDay)
                }
            }
        case .failed (let error):
            return item.changing { $0.state = .showingError(error: error) }
        case .noData:
            return item.changing { $0.state = .showingInfo(info: Text.youDontHaveAPlanYet) }
        }
    }

    private func transformItem(_ item: Item, applying state: State.LoadState<[NoonedDay: SunTime]>) -> Item {
        switch state {
        case .loading:
            return item.changing { $0.state = .loading }
        case .loaded(let sunTimes):
            guard let sunTime = sunTimes[item.id.day] else { return item }
            return item.changing {
                $0.state = .showingContent(
                    left: sunTime.sunrise.HHmmString,
                    right: sunTime.sunset.HHmmString
                )
            }
        case .failed (let error):
            return item.changing { $0.state = .showingError(error: error) }
        case .noData:
            return item.changing { $0.state = .showingInfo(info: Text.timeNotFound) }
        }
    }

    private func transformItems(with state: State, items: [Item]) -> [Item] {
        return items.map { item in
            switch item.id.kind {
            case .plan:
                return self.transformItem(item, applying: state.plan)
            case .sun:
                return self.transformItem(item, applying: state.sunTime)
            }
        }
    }

    private func makeItems(for state: State, day: NoonedDay, snapshot: Snapshot) -> [Item] {
        if snapshot.numberOfSections == 0 {
            return makeDefaultItems(for: day)
        } else {
            return transformItems(with: state, items: snapshot.itemIdentifiers(inSection: day))
        }
    }

    // MARK: - Default items -

    private func makeDefaultItems(for day: NoonedDay) -> [Item] {
        [
            .init(
                state: .loading,
                image: (
                    left: UIImage(systemName: "sunrise.fill") ?? UIImage(),
                    right: UIImage(systemName: "sunset.fill") ?? UIImage()
                ),
                title: (
                    left: Text.sunrise,
                    middle: Text.sunPosition,
                    right: Text.sunset
                ),
                id: Item.ID(kind: .sun, day: day)
            ),
            .init(
                state: .showingInfo(info: Text.youDontHaveAPlanYet),
                image: (
                    left: Asset.wakeup.image,
                    right: Asset.fallasleep.image
                ),
                title: (
                    left: Text.wakeUp,
                    middle: Text.scheduledSleep,
                    right: Text.toBed
                ),
                id: Item.ID(kind: .plan, day: day)
            )
        ]
    }
}

extension DaysViewController.State: Changeable {
    init(copy: ChangeableWrapper<DaysViewController.State>) {
        self.init(sunTime: copy.sunTime, plan: copy.plan)
    }
}

extension DaysCollectionCell.Model: Changeable {
    init(copy: ChangeableWrapper<DaysCollectionCell.Model>) {
        self.init(state: copy.state, image: copy.image, title: copy.title, id: copy.id)
    }
}
