//
//  Styles.swift
//  Rise
//
//  Created by Vladimir Korolev on 20.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Style {

    // MARK: - Layer

    struct Layer {

        private(set) var shadow = Shadow()
        private(set) var border = Border()
        private(set) var cornerRadius: CGFloat = 0

        // MARK: Instances

        static var usualBorder: Layer {
            Layer(border: .usual, cornerRadius: 16)
        }

        static var gloomingIcon: Layer {
            Layer(shadow: Shadow(
                radius: 15, opacity: 0.6,
                color: Asset.Colors.lightBlue.color.cgColor)
            )
        }

        // MARK: Shadow

        struct Shadow {
            private(set) var radius: CGFloat = 0
            private(set) var opacity: Float = 0
            private(set) var offset = CGSize(width: 0, height: 0)
            private(set) var color = UIColor.clear.cgColor

            // MARK: Instances

            static var usual: Shadow {
                .init(
                    radius: 12,
                    opacity: 0.41,
                    offset: CGSize(width: 0, height: 4),
                    color: Asset.Colors.lightBlue.color.cgColor
                )
            }

            static var whiteBgSeparatorBig: Shadow {
                .init(
                    radius: 10,
                    opacity: 0.5,
                    offset: .init(width: 0, height: 0),
                    color: Asset.Colors.black.color.cgColor
                )
            }

            static var onboardingShadow: Shadow {
                .init(
                    radius: 12,
                    opacity: 0.55,
                    offset: .init(width: 0, height: 0),
                    color: Asset.Colors.darkBlue.color.cgColor
                )
            }

            static var whiteBgSeparatorSmall: Shadow {
                .init(
                    radius: 8,
                    opacity: 0.25,
                    offset: .init(width: 0, height: 0),
                    color: Asset.Colors.black.color.cgColor
                )
            }
        }

        // MARK: Border

        struct Border {
            private(set) var color: CGColor = UIColor.clear.cgColor
            private(set) var width: CGFloat = 0

            // MARK: Instances

            static var usual: Border {
                Border(
                    color: Asset.Colors.whiteSeparator.color.cgColor,
                    width: 1
                )
            }
        }
    }

    // MARK: - TabBar

    enum TabBar {

        // MARK: Item

        struct Item {

            let iconColor: (normal: UIColor, selected: UIColor)

            // MARK: Instances

            static var usual: Item {
                Item(
                    iconColor: (
                        normal: Asset.Colors.whiteSeparator.color,
                        selected: Asset.Colors.white.color
                    )
                )
            }
        }
    }

    // MARK: - Text

    struct Text {

        let font: UIFont
        private(set) var color: UIColor?
        private(set) var alignment: NSTextAlignment?

        // MARK: Instances

        static var footer: Text {
            Text(font: .boldSystemFont(ofSize: 13), color: Asset.Colors.white.color, alignment: .center)
        }

        static var boldBigTitle: Text {
            Text(font: .boldSystemFont(ofSize: 30), color: Asset.Colors.white.color, alignment: .center)
        }

        static var bigSizedTitle: Text {
            Text(font: .preferredFont(forTextStyle: .largeTitle), color: Asset.Colors.white.color, alignment: .center)
        }

        static var mediumSizedTitle: Text {
            Text(font: .systemFont(ofSize: 18, weight: .medium), color: Asset.Colors.white.color, alignment: .center)
        }

        static var mediumSizedBody: Text {
            Text(font: .systemFont(ofSize: 18), color: Asset.Colors.white.color)
        }

        static var description: Text {
            Text(font: .systemFont(ofSize: 14), color: Asset.Colors.white.color.withAlphaComponent(0.7))
        }

        static var onTopOfRich: Text {
            Text(
                font: .systemFont(ofSize: 20, weight: .medium),
                color: Asset.Colors.darkBlue.color
            )
        }
    }

    // MARK: - Button

    struct Button {

        private(set) var disabledTitleColor: UIColor? = nil
        private(set) var selectedTitleColor: UIColor? = nil
        let titleStyle: Text
        private(set) var backgroundColor: UIColor = .clear
        private(set) var effects: Layer? = nil

        // MARK: Instances

        static var primary: Button {
            Button(
                disabledTitleColor: Asset.Colors.black.color.withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.boldSystemFont(ofSize: 18),
                    color: Asset.Colors.black.color
                ),
                backgroundColor: Asset.Colors.white.color,
                effects: Layer(
                    shadow: .usual,
                    cornerRadius: 22
                )
            )
        }

        static var image: Button {
            Button(
                disabledTitleColor: nil,
                selectedTitleColor: nil,
                titleStyle: .footer,
                backgroundColor: .clear,
                effects: nil
            )
        }

        static var secondary: Button {
            Button(
                disabledTitleColor: Asset.Colors.white.color.withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.systemFont(ofSize: 18),
                    color: Asset.Colors.white.color
                ),
                backgroundColor: .clear,
                effects: Layer(
                    border: .usual,
                    cornerRadius: 22
                )
            )
        }
    }
    
    // MARK: - Picker

    struct Picker {

        let textColor: UIColor
        let lineColor: UIColor

        // MARK: Instances

        static var usual: Picker {
            Picker(textColor: Asset.Colors.white.color, lineColor: .clear)
        }
    }

    // MARK: - Segmented control

    struct SegmentedControl {
        let selectionColor: UIColor
        let backgroundColor: UIColor
        let selectedTextColor: UIColor
        let normalTextColor: UIColor

        static var usual: SegmentedControl {
            .init(
                selectionColor: Asset.Colors.white.color.withAlphaComponent(0.3),
                backgroundColor: .clear,
                selectedTextColor: Asset.Colors.white.color,
                normalTextColor: Asset.Colors.white.color.withAlphaComponent(0.3)
            )
        }
    }
}

extension NSAttributedString {
    static func onTopOfRich(text: String) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                .strokeColor: Asset.Colors.lightBlue.color.withAlphaComponent(0.5),
                .foregroundColor: UIColor.white,
                .strokeWidth: -1.0
            ]
        )
    }

    static func descriptionOnTopOfRich(text: String, alignment: NSTextAlignment = .center) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.paragraphSpacing = 8
        return NSAttributedString(string: text, attributes: [
            .strokeColor: Asset.Colors.lightBlue.color.withAlphaComponent(0.7),
            .foregroundColor: UIColor.white,
            .strokeWidth: -1.0,
            .paragraphStyle: paragraphStyle
        ])
    }
}
