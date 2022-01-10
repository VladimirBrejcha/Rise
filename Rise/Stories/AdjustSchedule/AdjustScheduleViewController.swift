//  
//  AdjustScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 21.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AdjustScheduleViewController: UIViewController {

    private var loadedView: AdjustScheduleView {
        view as! AdjustScheduleView
    }

    private let adjustSchedule: AdjustSchedule
    private let currentSchedule: Schedule
    private let completion: ((Bool) -> Void)?
    private var selectedToBed: Date?

    // MARK: - LifeCycle

    init(
        adjustSchedule: AdjustSchedule,
        currentSchedule: Schedule,
        selectedToBed: Date? = nil,
        completion: ((Bool) -> Void)?
    ) {
        self.adjustSchedule = adjustSchedule
        self.currentSchedule = currentSchedule
        self.selectedToBed = selectedToBed
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view = AdjustScheduleView(
            closeHandler: { [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.completion?(false)
                })
            },
            saveHandler: { [weak self] in
                guard let self = self, let selectedToBed = self.selectedToBed else {
                    return
                }
                self.loadedView.allowSave(false)
                self.loadedView.allowEdit(false)
                self.adjustSchedule(
                    currentSchedule: self.currentSchedule,
                    newToBed: selectedToBed
                )
                self.loadedView.showSuccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true, completion: {
                        self.completion?(true)
                    })
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
            dateChangedHandler: { [weak self] date in
                guard let self = self else { return }
                self.loadedView.allowSave(
                    calendar.dateComponents([.hour, .minute], from: date)
                    != calendar.dateComponents([.hour, .minute], from: self.currentSchedule.toBed)
                )
                self.selectedToBed = date
            }
        )

        loadedView.allowEdit(selectedToBed == nil)
        loadedView.allowSave(selectedToBed != nil)
    }
}
