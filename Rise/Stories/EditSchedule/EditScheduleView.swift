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

    private lazy var titleView: UIView = View.Title.make(
        title: Text.editRiseSchedule,
        closeButton: .default { [weak self] in
            self?.closeHandler()
        }
    )

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
        button.setTitle(Text.save, for: .normal)
        button.onTouchUp = { [weak self] _ in
            self?.saveHandler()
        }
        return button
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
        addBackgroundView()
        addScreenTitleView(titleView)
        addSubviews(
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
        editScheduleTableView.activateConstraints(
            editScheduleTableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            editScheduleTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            editScheduleTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            editScheduleTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10)
        )
        saveButton.activateConstraints(
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        )
    }
}
