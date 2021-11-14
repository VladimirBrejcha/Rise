//
//  ScheduleView.swift
//  Rise
//
//  Created by Vladimir Korolev on 13.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ScheduleView: UIView, PropertyAnimatable, Statefull {
    
    @IBOutlet private var topLabel: UILabel!
    @IBOutlet private var centerLabel: UILabel!
    @IBOutlet private var middleButton: Button!
    @IBOutlet private var cellTopLeft: ImageLabelViewWithContextMenu!
    @IBOutlet private var cellTopRight: ImageLabelViewWithContextMenu!
    @IBOutlet private var cellBottomLeft: ImageLabelViewWithContextMenu!
    @IBOutlet private var cellBottomRight: ImageLabelViewWithContextMenu!

    // MARK: - PropertyAnimatable

    var propertyAnimationDuration: Double = 0.3

    // MARK: - Statefull -

    typealias CellState = ImageLabelViewWithContextMenu.State

    struct State {
        enum ShowCells {
            case yes(CellState, CellState, CellState, CellState)
            case no(reason: String)
        }
        let showCells: ShowCells
        let title: String
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
        topLabel.text = state.title
        middleButton.setTitle(state.middleButtonTitle, for: .normal)
        middleButton.onTouchDown = { _ in state.middleButtonHandler() }
    }

    // MARK: - Configuration -

    func configure() {
        centerLabel.applyStyle(.mediumSizedTitle)
        topLabel.applyStyle(.bigSizedTitle)
    }

    // MARK: - Internal -

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
            title: copy.title,
            middleButtonTitle: copy.middleButtonTitle,
            middleButtonHandler: copy.middleButtonHandler
        )
    }
}
