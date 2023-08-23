//
//  EditScheduleDatePickerTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary

final class EditScheduleDatePickerTableCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
{
    static var height: CGFloat { 200 }
    private var datePickerDelegate: ((Date) -> Void)?
    private var sleepDuration: Int = 8 * 60 {
        didSet {
            self.refreshWakeUpLabel(with: datePicker.date, sleepDuration: sleepDuration)
        }
    }

    // MARK: - Subviews

    private lazy var container: DesignableContainerView = {
        let container = DesignableContainerView()
        return container
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
        datePicker.applyStyle(.usual)
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged
        )
        return datePicker
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedBody)
        return label
    }()

    private lazy var wakeUpLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.footer)
        return label
    }()

    // MARK: - LifeCycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubviews(
            titleLabel,
            container.addSubviews(
                datePicker
            ),
            wakeUpLabel
        )
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        datePickerDelegate?(sender.date)
        refreshWakeUpLabel(with: sender.date, sleepDuration: sleepDuration)
    }

    // MARK: - Layout

    private func setupLayout() {
        titleLabel.activateConstraints {
            [$0.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
        }
        container.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)]
        }
        datePicker.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: container.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: container.trailingAnchor),
             $0.bottomAnchor.constraint(equalTo: container.bottomAnchor),
             $0.heightAnchor.constraint(equalToConstant: 140),
             $0.topAnchor.constraint(equalTo: container.topAnchor)]
        }
        wakeUpLabel.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
             $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
             $0.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 10),
             $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }
    }
    
    // MARK: - ConfigurableCell -

    func configure(with model: Model) {
        titleLabel.text = model.text
        datePicker.setDate(model.initialValue, animated: false)
        sleepDuration = model.initialSleepDuration
        model.sleepDurationObserver({ [weak self] sleepDuration in
            self?.sleepDuration = sleepDuration
        })
        datePickerDelegate = model.datePickerDelegate
    }

    private func refreshWakeUpLabel(with date: Date, sleepDuration: Int) {
        let wakeUpDate = date.addingTimeInterval(minutes: sleepDuration)
        wakeUpLabel.text = "Estimated wake up at \(wakeUpDate.HHmmString)"
    }
}
