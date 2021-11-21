//
//  EditScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 17.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleView: UIView {

    private let closeHandler: () -> Void
    private let saveHandler: () -> Void

    // MARK: - Subviews

    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.image = Asset.Background.default.image
        view.contentMode = .scaleAspectFill
        return view
    }()

    private lazy var editScheduleTableView: EditScheduleTableView = {
        let tableView = EditScheduleTableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private lazy var saveButton: Button = {
        let button = Button()
        button.setTitle("Save", for: .normal)
        button.onTouchUp = { [weak self] _ in
            self?.saveHandler()
        }
        return button
    }()

    private lazy var closeButton: Button = makeCloseButton(
        handler: { [weak self] in
            self?.closeHandler()
        }
    )

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedTitle)
        label.text = "Change Rise schedule"
        return label
    }()

    // MARK: - LifeCycle

    init(
        dataSource: UITableViewDataSource,
        delegate: UITableViewDelegate,
        closeHandler: @escaping () -> Void,
        saveHandler: @escaping () -> Void
    ) {
        self.closeHandler = closeHandler
        self.saveHandler = saveHandler
        super.init(frame: .zero)
        self.editScheduleTableView.delegate = delegate
        self.editScheduleTableView.dataSource = dataSource
        setupViews()
        setupLayout()
    }

    private func setupViews() {
        addSubviews(
            backgroundImageView,
            closeButton,
            titleLabel,
            editScheduleTableView,
            saveButton
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - Actions

    func getIndexPath(of cell: UITableViewCell) -> IndexPath? {
        editScheduleTableView.indexPath(for: cell)
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundImageView.activateConstraints(
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        )
        titleLabel.activateConstraints(
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor, constant: -2),
            titleLabel.bottomAnchor.constraint(equalTo: editScheduleTableView.topAnchor, constant: -10)
        )
        closeButton.activateConstraints(
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14),
            closeButton.widthAnchor.constraint(equalToConstant: 35),
            closeButton.heightAnchor.constraint(equalToConstant: 35),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        )
        editScheduleTableView.activateConstraints(
            editScheduleTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            editScheduleTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            editScheduleTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        )
        saveButton.activateConstraints(
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        )
    }
}
