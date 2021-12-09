//
//  ScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScheduleView: UIView, PropertyAnimatable, Statefull {

    // MARK: - PropertyAnimatable

    var propertyAnimationDuration: Double = 0.3

    // MARK: - Subviews

    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedTitle)
        return label
    }()

    private lazy var middleButton: Button = {
        let button = Button()
        button.onTouchUp = { [weak self] _ in
            self?.state?.middleButtonHandler()
        }
        return button
    }()

    private lazy var HStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    private lazy var VStackLeft: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private lazy var VStackRight: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var cellTopLeft = ImageLabelViewWithContextMenu()
    private lazy var cellTopRight = ImageLabelViewWithContextMenu()
    private lazy var cellBottomLeft = ImageLabelViewWithContextMenu()
    private lazy var cellBottomRight = ImageLabelViewWithContextMenu()

    // MARK: - LifeCycle

    init() {
        super.init(frame: .zero)
        setupViews()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupViews() {
        addSubviews(
            centerLabel,
            HStack.addArrangedSubviews(
                VStackLeft.addArrangedSubviews(
                    cellTopLeft,
                    cellBottomLeft
                ),
                VStackRight.addArrangedSubviews(
                    cellTopRight,
                    cellBottomRight
                )
            ),
            middleButton
        )
    }

    private func setupLayout() {
        centerLabel.activateConstraints(
            centerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            centerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            centerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        )

        HStack.activateConstraints(
            HStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            HStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            HStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            HStack.widthAnchor.constraint(equalTo: HStack.heightAnchor)
        )

        middleButton.activateConstraints(
            middleButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            middleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            middleButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            middleButton.heightAnchor.constraint(equalToConstant: 44)
        )
    }

    // MARK: - Statefull

    typealias CellState = ImageLabelViewWithContextMenu.State

    struct State {
        enum ShowCells {
            case yes(CellState, CellState, CellState, CellState)
            case no(reason: String)
        }
        let showCells: ShowCells
        let middleButtonTitle: String
        let middleButtonHandler: () -> Void
    }

    private(set) var state: State?
    func setState(_ state: State) {
        self.state = state
        
        switch state.showCells {
        case .yes(let topLeft, let topRight, let bottomLeft, let bottomRight):
            animate { [weak self] in
                self?.centerLabel.alpha = 0
                self?.applyToAllCells { $0.alpha = 1 }
            }
            cellTopLeft.setState(topLeft)
            cellTopRight.setState(topRight)
            cellBottomLeft.setState(bottomLeft)
            cellBottomRight.setState(bottomRight)
        case .no(let reason):
            centerLabel.text = reason
            animate { [weak self] in
                self?.centerLabel.alpha = 1
                self?.applyToAllCells { $0.alpha = 0 }
            }
        }
        middleButton.setTitle(state.middleButtonTitle, for: .normal)
    }

    // MARK: - Internal

    private func applyToAllCells(_ change: ((ImageLabelViewWithContextMenu) -> Void)) {
        change(cellTopLeft)
        change(cellTopRight)
        change(cellBottomLeft)
        change(cellBottomRight)
    }
}

extension ScheduleView.State: Changeable {
    init(copy: ChangeableWrapper<ScheduleView.State>) {
        self.init(
            showCells: copy.showCells,
            middleButtonTitle: copy.middleButtonTitle,
            middleButtonHandler: copy.middleButtonHandler
        )
    }
}
