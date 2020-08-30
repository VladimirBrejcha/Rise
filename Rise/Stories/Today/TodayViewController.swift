//
//  TodayViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 03/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

// TODO: (vladimir) - Fix a bug with error on initial load

final class TodayViewController: UIViewController, PropertyAnimatable {
    @IBOutlet private var todayView: TodayView!
    
    // MARK: - PropertyAnimatable
    var propertyAnimationDuration: Double { 0.15 }
    
    private typealias CellConfigurator
        = CollectionCellConfigurator<DaysCollectionCell, DaysCollectionCell.Model>
    
    private let sunImages = (left: "sunrise", right: "sunset")
    private let planImages = (left: "wakeup", right: "bed")
    
    var getSunTime: GetSunTime! // DI
    var getPlan: GetPlan! // DI
    var observePlan: ObservePlan! // DI
    var getDailyTime: GetDailyTime! // DI
    var confirmPlan: ConfirmPlan! // DI
    
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
    private var planNeedsUpdate: Bool = true
    private var suntimeNeedsUpdate: Bool = true
    private var latestPlan: RisePlan?
    private var latestSuntimes: [SunTime]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionDataSource = CollectionDataSource(items: [
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel),
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel),
            CellConfigurator(model: emptySunCellModel),
            CellConfigurator(model: emptyPlanCellModel)
        ])
        
        todayView.configure(
            dataSource: TodayView.DataSource(
                collection: collectionDataSource,
                timeUntilSleep:  { [weak self] in
                    self?.makeFloatingLabelModel() ?? FloatingLabel.Model(text: "", alpha: 0)
                }
            ),
            handlers: TodayView.Handlers(sleepHandler: { [weak self] in
                self?.present(Story.prepareToSleep(), with: .modal)
            })
        )
        
        requestSunTime { [weak self] sunTimes in
            guard let self = self else { return }
            self.latestSuntimes = sunTimes
            if self.viewIsVisible {
                self.updateDaysSunView(with: sunTimes)
            } else {
                self.suntimeNeedsUpdate = true
            }
        }
        
        latestPlan = try? getPlan()
        observePlan.observe { [weak self] plan in
            guard let self = self else { return }
            self.latestPlan = plan
            if self.viewIsVisible {
                self.updateDaysPlanView(with: plan)
            } else {
                self.planNeedsUpdate = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewIsVisible = true
        
        if planNeedsUpdate {
            updateDaysPlanView(with: latestPlan)
            planNeedsUpdate = false
        }
        
        if suntimeNeedsUpdate {
            updateDaysSunView(with: latestSuntimes)
            suntimeNeedsUpdate = false
        }
        
        if let confirmed = try? confirmPlan.checkIfConfirmed() {
            makeTabBar(visible: confirmed)
            if !confirmed {
                present(Story.confirmation(), with: .overContext)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewIsVisible = false
    }
    
    // MARK: - Private
    private func makeTabBar(visible: Bool) {
        animate {
            self.tabBarController?.tabBar.alpha = visible ? 1 : 0
        }
    }
    
    private func requestSunTime(_ completion: @escaping ([SunTime]?) -> Void) {
        getSunTime(for: (numberOfDays: 3, since: NoonedDay.yesterday.date)) {
            if case .success (let sunTime) = $0 {
                completion(sunTime)
            }
            if case .failure (let error) = $0 {
                log(.error, with: "Error on requestSunTime: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    private func updateDaysSunView(with sunTimes: [SunTime]?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.indices {
            if index.isOdd { continue } // odd is for planViews
            
            if let sunTimes = sunTimes {
                let sunTime = sunTimes[index / 2]
                cellModels[index].state = .showingContent(
                    left: sunTime.sunrise.HHmmString,
                    right: sunTime.sunset.HHmmString
                )
            } else {
                cellModels[index].state = .showingError(error: "Failed to load data")
            }
            
            itemsToReload.append(index)
        }
        todayView.reloadItems(at: itemsToReload)
    }
    
    private func updateDaysPlanView(with plan: RisePlan?) {
        var itemsToReload = [Int]()
        
        for index in cellModels.indices {
            if index.isEven { continue } // even is for sunViews
            
            if plan != nil {
                let datesArray: [NoonedDay] = [.yesterday, .today, .tomorrow]
                
                if let dailyTime = try? getDailyTime(for: datesArray[(index / 2)].date) {
                    cellModels[index].state = .showingContent(
                        left: dailyTime.wake.HHmmString,
                        right: dailyTime.sleep.HHmmString
                    )
                } else {
                    cellModels[index].state = .showingInfo(info: "No plan for the day")
                }
            } else {
                cellModels[index].state = .showingInfo(info: "You don't have a plan yet")
            }
            
            itemsToReload.append(index)
        }
        todayView.reloadItems(at: itemsToReload)
    }
    
    private func makeFloatingLabelModel() -> FloatingLabel.Model {
        guard let plan = latestPlan else {
            return FloatingLabel.Model(text: "", alpha: 0)
        }
        
        if plan.paused {
            return FloatingLabel.Model(text: "Your personal plan is on pause", alpha: 0.85)
            
        } else {
            guard let todayDailyTime = try? getDailyTime(for: NoonedDay.today.date) else {
                return FloatingLabel.Model(text: "", alpha: 0)
            }
            
            guard let minutesUntilSleep = calendar.dateComponents(
                [.minute],
                from: Date(),
                to: todayDailyTime.sleep
            ).minute else {
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
        guard let index = todayView.getIndexOf(cell: cell) else { return }
        
        cellModels[index].state = .loading
        todayView.reloadItem(at: index)
        index.isEven
            ? requestSunTime { [weak self] sunTimes in
                guard let self = self else { return }
                self.latestSuntimes = sunTimes
                if self.viewIsVisible {
                    self.updateDaysSunView(with: sunTimes)
                } else {
                    self.suntimeNeedsUpdate = true
                }
              }
            : updateDaysPlanView(with: latestPlan)
    }
}
