//
//  EditScheduleDatePickerTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleDatePickerTableCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
{
    static var height: CGFloat { 180 }
    private var datePickerDelegate: ((Date) -> Void)?

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
            )
        )
    }
    
    @IBAction private func datePickerValueChanged(_ sender: UIDatePicker) {
        datePickerDelegate?(sender.date)
    }

    // MARK: - Layout

    private func setupLayout() {
        titleLabel.activateConstraints(
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        )
        container.activateConstraints(
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)
        )
        datePicker.activateConstraints(
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 140),
            datePicker.topAnchor.constraint(equalTo: container.topAnchor)
        )
    }
    
    // MARK: - ConfigurableCell -

    func configure(with model: Model) {
        titleLabel.text = model.text
        datePicker.setDate(model.initialValue, animated: false)
        datePickerDelegate = model.datePickerDelegate
    }
}
