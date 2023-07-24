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
    @IBOutlet private var intensityIconView: UIImageView!

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
                    self?.refreshIcon(with: .low)
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
                    self?.refreshIcon(with: .normal)
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
                    self?.refreshIcon(with: .high)
                }
            ),
            at: 2,
            animated: false
        )
        let intensity = currentIntensity?() ?? defaultIntensity
        intensitySegmentedControl.selectedSegmentIndex = intensity.index
        refreshDescriptionLabel(with: intensity)
        refreshIcon(with: intensity)
        intensityIconView.layer.applyStyle(.gloomingIcon)
    }

    private func refreshIcon(with intensity: Schedule.Intensity) {
        intensityIconView.image = UIImage(systemName: intensity.iconName)
    }

    private func refreshDescriptionLabel(with intensity: Schedule.Intensity) {
        intensityDescriptionLabel.text = {
            switch intensity {
            case .low:
                return "Gentle Journey.\nMake gradual changes to your sleep pattern. Ideal if you prefer a slow and steady transition."
            case .normal:
                return "Balanced Pace.\nRecommended for a smooth transition to your ideal sleep schedule."
            case .high:
                return "Rapid Route.\nMake swift changes to your sleep habits. Best if you want quick results, but it could be challenging."
            }
        }()
    }
}
