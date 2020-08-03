//
//  TodayStoryViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TodayViewController: UIViewController {
    @IBOutlet private var todayView: TodayView!
    
    private typealias CellConfigurator
        = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCell.Model>
    
    private let sunImages = (left: "sunrise", right: "sunset")
    private let planImages = (left: "wakeup", right: "bed")
    
    var getSunTime: GetSunTime! // DI
    var getPlan: GetPlan! // DI
    var observePlan: ObservePlan! // DI
    var getDailyTime: GetDailyTime! // DI
    var confirmPlan: ConfirmPlan! // DI
    
    private var latestUsedPlan: RisePlan?
    private var collectionDataSource: CollectionDataSource!
    private var cellModels: [DaysCollectionCell.Model] {
        get {
            if let dataSource = collectionDataSource {
                return dataSource
                    .items
                    .compactMap { $0 as? CellConfigurator }
                    .map { $0.model }
            } else {
                return []
            }
        }
        set {
            collectionDataSource?.items = newValue.map { CellConfigurator(model: $0) }
        }
    }
    private var viewIsVisible: Bool = false
    private var needsUpdate: Bool = true
    private let player = AudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayView.sleepTouchUpHandler = { [weak self] in
            guard let self = self else { return }
            Presenter.present(
                controller: Story.prepareToSleep.configure(),
                with: .modal,
                presentingController: self
            )
        }
        
        latestUsedPlan = try? getPlan.execute()
        
        collectionDataSource = CollectionDataSource(items: [
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel),
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel),
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel)
        ])
        
        todayView.daysCollectionView.dataSource = collectionDataSource
        
        requestSunTime()

        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            self.latestUsedPlan = plan
            self.viewIsVisible
                ? { self.todayView.timeToSleepDataSource = self.floatingLabelDataSource
                    self.updateDaysPlanView(with: plan)}()
                : { self.needsUpdate = true }()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewIsVisible = true
        if needsUpdate {
            todayView.timeToSleepDataSource = floatingLabelDataSource
            self.updateDaysPlanView(with: latestUsedPlan)
            needsUpdate = false
        }
        if let confirmed = try? confirmPlan.checkIfConfirmed() {
            makeTabBar(visible: confirmed)
            if !confirmed {
                Presenter.present(
                    controller: Story.confirmation.configure(),
                    with: .overContext,
                    presentingController: self
                )
            }
        }
        //        playSound()
        try! player.play(sound: AlarmSounds.bellAlarm)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                viewIsVisible = false
    }
    
    func reloadItem(at index: Int) {
        todayView.daysCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func reloadItems(at indexes: [Int]) {
        todayView.daysCollectionView.reloadItems(at: indexes.map { IndexPath(item: $0, section: 0) })
    }
    
    func reloadCollection() {
        todayView.daysCollectionView.reloadData()
    }
    
    func makeTabBar(visible: Bool) {        
        UIView.animate(withDuration: 0.15) {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
    
    private func requestSunTime() {
        getSunTime.execute(for: (numberOfDays: 3, day: NoonedDay.yesterday.date)) { [weak self] result in
            if case .success (let sunTime) = result { self?.updateDaysSunView(with: sunTime) }
            if case .failure = result { self?.updateDaysSunView(with: nil) }
        }
    }
    // MARK: - Update days view
    private func updateDaysSunView(with sunTimes: [SunTime]?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.enumerated() {
            if index.offset.isOdd { continue }
            
            if let sunTimes = sunTimes {
                let sunTime = sunTimes[index.offset / 2]
                cellModels[index.offset].state = .showingContent(left: sunTime.sunrise.HHmmString,
                                                                 right: sunTime.sunset.HHmmString)
            } else {
                cellModels[index.offset].state = .showingError(error: "Failed to load data")
            }
            
            itemsToReload.append(index.offset)
        }
        
        reloadItems(at: itemsToReload)
    }
    
    private func updateDaysPlanView(with plan: RisePlan?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.enumerated() {
            if index.offset.isEven { continue }
            
            if plan != nil {
                let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
                
                if let dailyTime = try? getDailyTime.execute(for: datesArray[(index.offset / 2)].date) {
                    cellModels[index.offset].state = .showingContent(left: dailyTime.wake.HHmmString,
                                                                     right: dailyTime.sleep.HHmmString)
                } else {
                    cellModels[index.offset].state = .showingInfo(info: "No plan for the day")
                }
                
            }
            else {
                cellModels[index.offset].state = .showingInfo(info: "You don't have a plan yet")
            }
            
            itemsToReload.append(index.offset)
            
        }
        reloadItems(at: itemsToReload)
    }
    
    private func getIndexOf(cell: DaysCollectionCell) -> Int? {
        todayView.daysCollectionView.indexPath(for: cell)?.row
    }
    
    // MARK: - Floating label data source
    private func floatingLabelDataSource() -> FloatingLabel.Model {
        guard let plan = latestUsedPlan else {
            return FloatingLabel.Model(text: "", alpha: 0)
        }
        
        if plan.paused {
            return FloatingLabel.Model(text: "Your personal plan is on pause", alpha: 0.85)
        } else {
            guard let todayDailyTime = try? getDailyTime.execute(for: Date().noon)
                else {
                    return FloatingLabel.Model(text: "", alpha: 0)
            }
            
            guard let minutesUntilSleep = calendar.dateComponents(
                [.minute],
                from: Date(),
                to: todayDailyTime.sleep
            ).minute
                else {
                    return FloatingLabel.Model(text: "", alpha: 0)
            }
            
            let minutesInDay: Float = 24 * 60
            
            let sleepDuration = plan.sleepDurationSec
            if Float(minutesUntilSleep) >= minutesInDay - Float(sleepDuration / 60) {
                return FloatingLabel.Model(text: "It's time to sleep!", alpha: 0.85)
            }
            
            var alpha: Float = (minutesInDay - Float(minutesUntilSleep)) / minutesInDay
            if alpha < 0.3 { alpha = 0.3 }
            if alpha > 0.85 { alpha = 0.85 }
            let timeString = minutesUntilSleep.HHmmString
            
            return FloatingLabel.Model(text: "Sleep planned in \(timeString)", alpha: alpha)
        }
    }
    
    private var emptySunCellModel: DaysCollectionCell.Model {
        DaysCollectionCell.Model(
            state: .loading,
            imageName: sunImages,
            repeatHandler: { [weak self] cell in
                self?.repeatButtonPressed(on: cell)
            }
        )
    }
    private var emptyPlanCellModel: DaysCollectionCell.Model {
        DaysCollectionCell.Model(
            state: .loading,
            imageName: planImages,
            repeatHandler: { [weak self] cell in
                self?.repeatButtonPressed(on: cell)
            }
        )
    }
    
    private func repeatButtonPressed(on cell: DaysCollectionCell) {
        guard let index = getIndexOf(cell: cell)
            else {
                return
        }
        
        cellModels[index].state = .loading
        
        reloadItem(at: index)
        
        index.isEven
            ? requestSunTime()
            : updateDaysPlanView(with: latestUsedPlan)
    }
}

fileprivate extension Int {
    var isEven: Bool { return self % 2 == 0 }
    
    var isOdd: Bool { return self % 2 != 0 }
}

