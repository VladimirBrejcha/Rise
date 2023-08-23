//
//  EditScheduleButtonTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary

final class EditScheduleButtonTableCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
{
    static var height: CGFloat { 60 }

    // MARK: - Subviews

    private lazy var button: Button = {
        let button = Button()
        button.applyStyle(.secondary)
        return button
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
            button
        )
    }

    // MARK: - Layout

    private func setupLayout() {
        button.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            $0.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }
    }

    // MARK: - ConfigurableCell

    func configure(with model: Model) {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(Asset.Colors.red.color, for: .normal)
        button.onTouchUp = { model.action() }
    }
}
