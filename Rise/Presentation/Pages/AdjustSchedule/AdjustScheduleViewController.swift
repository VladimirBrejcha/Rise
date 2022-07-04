//  
//  AdjustScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

final class AdjustScheduleViewController: UIViewController, ViewController {

  enum OutCommand {
    case cancelAdjustment
    case adjustmentCompleted
  }
  typealias Deps = HasAdjustScheduleUseCase
  typealias Params = (currentSchedule: Schedule, toBed: Date?)
  typealias View = AdjustScheduleView
  
  private let adjustSchedule: AdjustSchedule
  private let currentSchedule: Schedule
  private var selectedToBed: Date?

  private let out: Out
  
  // MARK: - LifeCycle
  
  init(deps: Deps, params: Params, out: @escaping Out) {
    self.adjustSchedule = deps.adjustSchedule
    self.currentSchedule = params.currentSchedule
    self.selectedToBed = params.toBed
    self.out = out
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    self.view = AdjustScheduleView(
      closeHandler: { [unowned self] in out(.cancelAdjustment) },
      saveHandler: { [unowned self] in
        guard let selectedToBed = selectedToBed else {
          return
        }
        rootView.allowSave(false)
        rootView.allowEdit(false)
        adjustSchedule(
          currentSchedule: currentSchedule,
          newToBed: selectedToBed
        )
        rootView.showSuccess()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          self.out(.adjustmentCompleted)
        }
      },
      descriptionText: {
        if let selectedToBed = selectedToBed {
          return """
                 \(Text.adjustScheduleWannaAdjust)

                 \(Text.adjustScheduleNextSleep)\(selectedToBed.HHmmString)
                 """
        } else {
          return """
                 \(Text.adjustScheduleSuggestionToAdjust)

                 \(Text.lastTimeIWentSleepAt):
                 """
        }
      }(),
      initialDate: selectedToBed ?? currentSchedule.toBed,
      dateChangedHandler: { [unowned self] date in
        rootView.allowSave(
          calendar.dateComponents([.hour, .minute], from: date)
          != calendar.dateComponents([.hour, .minute], from: self.currentSchedule.toBed)
        )
        selectedToBed = date
      }
    )
    
    rootView.allowEdit(selectedToBed == nil)
    rootView.allowSave(selectedToBed != nil)
  }
}
