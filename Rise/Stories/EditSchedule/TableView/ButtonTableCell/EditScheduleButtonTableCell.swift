//
//  EditScheduleButtonTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 11.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class EditScheduleButtonTableCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
{
    static var height: CGFloat { 58 }

    // MARK: - Subviews

    private lazy var button: Button = {
        let button = Button()
        button.applyStyle(.red)
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
        button.activateConstraints(
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        )
    }

    // MARK: - ConfigurableCell

    func configure(with model: Model) {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(Asset.Colors.red.color, for: .normal)
        button.onTouchUp = { _ in model.action() }
    }
}
