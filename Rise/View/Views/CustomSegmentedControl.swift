//
//  CustomSegmentedControl.swift
//  Rise
//
//  Created by Vladimir Korolev on 15/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum SegmentedControlCases {
    case yesterday
    case today
    case tomorrow
    
    var dayDescription: String {
        switch self {
        case .yesterday:
            return "yesterday"
        case .today:
            return "today"
        case .tomorrow:
            return "tomorrow"
        }
    }
}

protocol CustomSegmentedControlDelegate: class {
    func segmentedButtonPressed(_ segment: SegmentedControlCases)
}

@IBDesignable
class CustomSegmentedControl: UIControl {
    weak var delegate: CustomSegmentedControlDelegate?
    
    private(set) var buttons = [UIButton]()
    private(set) var selectedSegmentIndex = 1
    private(set) var buttonTitlesArray: [String] = [] {
        didSet { updateView() }
    }
    var textColor: UIColor = UIColor.white.withAlphaComponent(0.5) {
        didSet { updateView() }
    }
    var selectorTextColor: UIColor = .white {
        didSet { updateView() }
    }
    
    init(buttonTitles: [String], startingIndex: Int) {
        super.init(frame: .zero)
        buttonTitlesArray = buttonTitles
        selectedSegmentIndex = startingIndex
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    // MARK: UpdateView
    private func updateView() {
        removeOld()
        addNew()
        addStackView()
    }
    private func removeOld() {
        buttons.removeAll()
        subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    private func addNew() {
        for buttonTitle in buttonTitlesArray {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12.5)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[selectedSegmentIndex].setTitleColor(selectorTextColor, for: .normal)
    }
    private func addStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    // MARK: ButtonTapped
    @objc func buttonTapped(button: UIButton) {
        switch button.currentTitle {
        case SegmentedControlCases.yesterday.dayDescription:
            delegate?.segmentedButtonPressed(.yesterday)
        case SegmentedControlCases.today.dayDescription:
            delegate?.segmentedButtonPressed(.today)
        case SegmentedControlCases.tomorrow.dayDescription:
            delegate?.segmentedButtonPressed(.tomorrow)
        default:
            fatalError("wrong case in buttonTapped")
        }
        
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                selectedSegmentIndex = buttonIndex
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }
}
