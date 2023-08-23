//
//  EditScheduleSliderTableCell.swift
//  Rise
//
//  Created by Vladimir Korolev on 24.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import UILibrary

final class EditScheduleSliderTableCell:
    UITableViewCell,
    ConfigurableCell,
    SelfHeightSizing
{
    static var height: CGFloat { 130 }

    // MARK: - Subviews

    private lazy var container: DesignableContainerView = {
        let container = DesignableContainerView()
        return container
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.applyStyle(.mediumSizedBody)
        return label
    }()

    private lazy var slider: SliderWithValues = {
        let slider = SliderWithValues()
        return slider
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
                slider
            )
        )
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
            $0.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            $0.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2)]
        }
        slider.activateConstraints {
            [$0.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            $0.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            $0.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            $0.heightAnchor.constraint(equalToConstant: 90),
            $0.topAnchor.constraint(equalTo: container.topAnchor)]
        }
    }

    // MARK: - ConfigurableCell
    
    func configure(with model: Model) {
        titleLabel.text = model.title
        slider.leftLabel.text = model.text.left
        slider.centerLabel.text = model.text.center
        slider.rightLabel.text = model.text.right
        slider.slider.minimumValue = model.sliderMinValue
        slider.slider.maximumValue = model.sliderMaxValue
        slider.slider.setValue(model.sliderValue, animated: true)
        slider.centerLabelDataSource = { [weak self] in
            guard let self = self else { return "" }
            return model.centerLabelDataSource(self, $0)
        }
    }
}
