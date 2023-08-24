//
//  SelectAlarmMelodyView.swift
//  Rise
//
//  Created by Vladimir Korolev on 24/8/23.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary
import Localization

final class SelectAlarmMelodyView: UIView {

    private let saveHandler: () -> Void
    private let closeHandler: () -> Void
    private let itemSelected: (String) -> Void

    private let items: [String]
    var selectedItem: String {
        didSet {
            if selectedItem == oldValue { return }
            itemViews.forEach {
                $0.isSelected = $0.title == selectedItem
            }
        }
    }

    // MARK: - Subviews

    private lazy var titleView: UIView = Title.make(
        title: Text.Settings.Title.selectAlarmMelody,
        closeButton: .default { [weak self] in
            self?.closeHandler()
        }
    )

    private lazy var saveButton: Button = {
        let button = Button()
        button.setTitle(Text.save, for: .normal)
        button.onTouchUp = { [weak self] in
            self?.saveHandler()
        }
        return button
    }()

    private lazy var VStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.clipsToBounds = true
        stack.layer.applyStyle(.usualBorder)
        return stack
    }()

    private lazy var itemViews: [ItemView] = {
        items.map { title in
            ItemView(
                title: title,
                selected: title == selectedItem,
                onTouch: { [weak self] in
                    self?.itemSelected(title)
                }
            )
        }
    }()
    // MARK: - LifeCycle

    init(items: [String],
         selectedItem: String,
         itemSelected: @escaping (String) -> Void,
         saveHandler: @escaping () -> Void,
         closeHandler: @escaping () -> Void
    ) {
        self.closeHandler = closeHandler
        self.saveHandler = saveHandler
        self.items = items
        self.itemSelected = itemSelected
        self.selectedItem = selectedItem
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
        setupLayout()
    }

    func setupViews() {
        addBackgroundView()
        addScreenTitleView(titleView)
        addSubviews(
            VStack.addArrangedSubviews(itemViews, separated: true),
            saveButton
        )
    }

    func setupLayout() {
        VStack.activateConstraints {
            [$0.centerYAnchor.constraint(equalTo: centerYAnchor),
             $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)]
        }
        VStack.arrangedSubviews.forEach { view in
            view.activateConstraints {
                [$0.heightAnchor.constraint(equalToConstant: 48),
                 $0.widthAnchor.constraint(equalTo: VStack.widthAnchor)]
            }
        }
        saveButton.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
             $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
             $0.heightAnchor.constraint(equalToConstant: 44),
             $0.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)]
        }
    }

    // MARK: - ItemView

    class ItemView: UIView, PropertyAnimatable {

        private var touchHandler: () -> Void

        var isSelected: Bool {
            didSet {
                if isSelected == oldValue { return }
                drawSelection(isSelected)
            }
        }
        let title: String

        var propertyAnimationDuration: Double { 0.2 }
        private let normalBgColor = Asset.Colors.white.color.withAlphaComponent(0.1)
        private let selectedBgColor = Asset.Colors.white.color.withAlphaComponent(0.3)

        // MARK: - Subviews

        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.applyStyle(.mediumSizedBody)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.7
            label.textAlignment = .center
            return label
        }()

        // MARK: - LifeCycle

        init(title: String, selected: Bool,
             onTouch: @escaping () -> Void
        ) {
            self.title = title
            self.isSelected = selected
            self.touchHandler = onTouch
            super.init(frame: .zero)
            setup()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setup() {
            setupViews()
            setupLayout()
        }

        private func setupViews() {
            addSubviews(
                titleLabel
            )
            titleLabel.text = title
            backgroundColor = normalBgColor
            if isSelected { drawSelection(true) }
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            if let touch = touches.first {
                if point(
                    inside: touch.location(in: self),
                    with: event
                ) {
                    touchHandler()
                }
            }
        }

        func drawSelection(_ draw: Bool) {
            animate {
                self.backgroundColor = draw ? self.selectedBgColor : self.normalBgColor
            }
        }

        // MARK: - Layout

        private func setupLayout() {
            titleLabel.activateConstraints {
                [$0.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                 $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                 $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)]
            }
        }
    }
}
