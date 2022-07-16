//
//  IntensityCreateScheduleViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 16.11.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import Core

final class IntensityCreateScheduleViewController: UIViewController {

    @IBOutlet private var intensityDescriptionLabel: UILabel!
    @IBOutlet private var intensitySegmentedControl: UISegmentedControl!

    var scheduleIntensityOutput: ((Schedule.Intensity) -> Void)? // DI
    var currentIntensity: (() -> Schedule.Intensity?)? // DI

    private let defaultIntensity: Schedule.Intensity = .normal

    override func viewDidLoad() {
        super.viewDidLoad()

        intensitySegmentedControl.applyStyle(.usual)
        intensitySegmentedControl.removeAllSegments()
        intensitySegmentedControl.insertSegment(
            action: .init(
                title: Schedule.Intensity.low.description,
                handler: { [weak self] _ in
                    self?.scheduleIntensityOutput?(.low)
                    self?.refreshDescriptionLabel(with: .low)
                }
            ),
            at: 0,
            animated: false
        )
        intensitySegmentedControl.insertSegment(
            action: .init(
                title: Schedule.Intensity.normal.description,
                handler: { [weak self] _ in
                    self?.scheduleIntensityOutput?(.normal)
                    self?.refreshDescriptionLabel(with: .normal)
                }
            ),
            at: 1,
            animated: false
        )
        intensitySegmentedControl.insertSegment(
            action: .init(
                title: Schedule.Intensity.high.description,
                handler: { [weak self] _ in
                    self?.scheduleIntensityOutput?(.high)
                    self?.refreshDescriptionLabel(with: .high)
                }
            ),
            at: 2,
            animated: false
        )
        let intensity = currentIntensity?() ?? defaultIntensity
        intensitySegmentedControl.selectedSegmentIndex = intensity.index
        refreshDescriptionLabel(with: intensity)
    }

    private func refreshDescriptionLabel(with intensity: Schedule.Intensity) {
        intensityDescriptionLabel.text = {
            switch intensity {
            case .low:
                return "Smoothly and calmly reach the target"
            case .normal:
                return "Recommended: middle pace"
            case .high:
                return "Achieve the goal most quickly"
            }
        }()
    }
}
