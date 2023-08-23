//
//  DaysView.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/09/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView
import DataLayer
import UILibrary

extension Days {

    final class View: UIView, SelectableStackViewDelegate {

        var snapshot: CollectionView.Snapshot? { daysCollection.snapshot }
        private let cellProvider: CollectionView.CellProvider
        private let sectionTitles: [String]

        // MARK: - Subviews

        private lazy var segmentedControl: SelectableStackView = {
            let view = SelectableStackView()
            view.axis = .horizontal
            view.distribution = .fillEqually
            view.delegate = self
            return view
        }()

        private lazy var daysCollection: CollectionView = {
            let collection = CollectionView(
                pageScrollHandler: { [weak self] page in
                    if page >= 0 && page <= 2 {
                        self?.segmentedControl.select(true, at: page)
                    }
                },
                cellProvider: cellProvider
            )
            collection.backgroundColor = .clear
            collection.showsHorizontalScrollIndicator = false
            collection.isPagingEnabled = true
            collection.layer.cornerRadius = 16
            return collection
        }()

        private lazy var legalImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        private lazy var legalLabel: UITextView = {
            let label = UITextView()
            label.backgroundColor = .clear
            label.textContainerInset = .zero
            label.isEditable = false
            label.isScrollEnabled = false
            label.showsVerticalScrollIndicator = false
            label.showsHorizontalScrollIndicator = false
            return label
        }()

        // MARK: - LifeCycle

        init(cellProvider: @escaping CollectionView.CellProvider, sectionTitles: [String]) {
            self.cellProvider = cellProvider
            self.sectionTitles = sectionTitles
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
                segmentedControl.addArrangedSubviews(
                    sectionTitles.map(SelectableStackViewButton.init(title:))
                ),
                daysCollection,
                legalImageView,
                legalLabel
            )
        }

        private func setupLayout() {
            segmentedControl.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
                $0.heightAnchor.constraint(equalToConstant: 20),
                $0.topAnchor.constraint(equalTo: topAnchor)]
            }
            daysCollection.activateConstraints {
                [$0.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 4),
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor)]
            }
            legalImageView.activateConstraints {
                [$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                 $0.bottomAnchor.constraint(equalTo: bottomAnchor),
                 $0.heightAnchor.constraint(equalToConstant: 12),
                 $0.widthAnchor.constraint(equalToConstant: 48),
                 $0.topAnchor.constraint(equalTo: daysCollection.bottomAnchor, constant: 2)]
            }
            legalLabel.activateConstraints {
                [$0.topAnchor.constraint(equalTo: daysCollection.bottomAnchor, constant: 0),
                 $0.widthAnchor.constraint(equalToConstant: 48),
                 $0.heightAnchor.constraint(equalToConstant: 16),
                 $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)]
            }
        }

        // MARK: - Actions

        func centerItems() {
            daysCollection.scrollToPage(1, animated: false)
            segmentedControl.select(true, at: 1)
        }

        func applySnapshot(_ snapshot: CollectionView.Snapshot) {
            daysCollection.applySnapshot(snapshot)
        }

        func applyLegal(_ legal: WKLegal?) {
            guard let legal else {
                legalLabel.isHidden = true
                legalImageView.isHidden = true
                return
            }
            legalLabel.isHidden = false
            legalImageView.isHidden = false
            legalImageView.image = UIImage(data: legal.img)
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .right
            paragraph.paragraphSpacingBefore = 0
            paragraph.lineSpacing = 0
            paragraph.paragraphSpacing = 0
            let attributes: [NSAttributedString.Key: Any] = [
                .backgroundColor: UIColor.clear,
                .link: legal.url,
                .font: UIFont.systemFont(ofSize: 11, weight: .medium),
                .paragraphStyle: paragraph,
                .underlineColor: UIColor.white.withAlphaComponent(0.7),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            let attributedString = NSMutableAttributedString(string: "Legal", attributes: attributes)
            legalLabel.attributedText = attributedString
            legalLabel.linkTextAttributes = [.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        }

        // MARK: - SelectableStackViewDelegate

        func didSelect(_ select: Bool, at index: Index, on selectableStackView: SelectableStackView) {
            if select {
                daysCollection.scrollToPage(index)
            }
        }
    }
}
