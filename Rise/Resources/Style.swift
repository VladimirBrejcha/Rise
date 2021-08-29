//
//  Styles.swift
//  Rise
//
//  Created by Владимир Королев on 20.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Style {

    // MARK: - Layer
    struct Layer {

        private(set) var shadow = Shadow()
        private(set) var border = Border()
        private(set) var cornerRadius: CGFloat = 0

        // MARK: - Shadow
        struct Shadow {
            private(set) var radius: CGFloat = 0
            private(set) var opacity: Float = 0
            private(set) var offset = CGSize(width: 0, height: 0)
            private(set) var color = UIColor.clear.cgColor
        }

        // MARK: - Border
        struct Border {
            private(set) var color: CGColor = UIColor.clear.cgColor
            private(set) var width: CGFloat = 0

            // MARK: - Instances
            static var usual: Border {
                Border(color: UIColor.white.withAlphaComponent(0.85).cgColor, width: 1)
            }
        }

        // MARK: - Instances
        static var usual: Layer {
            Layer(border: .usual, cornerRadius: 12)
        }
    }

    // MARK: - TabBar
    enum TabBar {

        // MARK: - Item
        struct Item {

            let titleColor: (normal: UIColor, selected: UIColor)
            let iconColor: (normal: UIColor, selected: UIColor)

            // MARK: - Instances
            static var usual: Item {
                Item(titleColor: (
                    normal: .clear,
                    selected: .white
                ),
                iconColor: (
                    normal: UIColor.white.withAlphaComponent(0.85),
                    selected: .white
                ))
            }
        }
    }

    // MARK: - Text
    struct Text {

        let font: UIFont
        private(set) var color: UIColor?
        private(set) var alignment: NSTextAlignment?

        // MARK: - Instances
        static var notificationLabel: Text {
            Text(font: .boldSystemFont(ofSize: 13))
        }

        static var bigSizedTitle: Text {
            Text(font: .preferredFont(forTextStyle: .largeTitle), color: .white, alignment: .center)
        }

        static var mediumSizedTitle: Text {
            Text(font: .systemFont(ofSize: 18, weight: .medium), color: .white, alignment: .center)
        }

        static var mediumSizedBody: Text {
            Text(font: .systemFont(ofSize: 18), color: .white)
        }
    }

    // MARK: - Button
    struct Button {

        let disabledTitleColor: UIColor?
        let titleStyle: Text
        let backgroundColor: UIColor
        let effects: Layer
        let scaleTransform: CGAffineTransform

        // MARK: - Instances
        static var primary: Button {
            Button(
                disabledTitleColor: #colorLiteral(red: 0.07450980392, green: 0.2078431373, blue: 0.3019607843, alpha: 1).withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.boldSystemFont(ofSize: 18),
                    color: #colorLiteral(red: 0.07450980392, green: 0.2078431373, blue: 0.3019607843, alpha: 1)
                ),
                backgroundColor: .white,
                effects: Layer(
                    shadow: Layer.Shadow(
                        radius: 12,
                        opacity: 0.41,
                        offset: CGSize(width: 0, height: 4),
                        color: #colorLiteral(red: 0.4431372549, green: 1, blue: 0.8980392157, alpha: 1).cgColor
                    ),
                    cornerRadius: 25
                ),
                scaleTransform: CGAffineTransform(scaleX: 0.98, y: 0.95)
            )
        }

        static var secondary: Button {
            Button(
                disabledTitleColor: UIColor.white.withAlphaComponent(0.5),
                titleStyle: Text(
                    font: UIFont.boldSystemFont(ofSize: 18),
                    color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                ),
                backgroundColor: .clear,
                effects: Layer(
                    border: Layer.Border(
                        color: UIColor.white.cgColor,
                        width: 1
                    ),
                    cornerRadius: 25
                ),
                scaleTransform: CGAffineTransform(scaleX: 0.98, y: 0.95)
            )
        }
    }
    
    // MARK: - Picker
    struct Picker {
        let textColor: UIColor
        let lineColor: UIColor

        // MARK: - Instances
        static var usual: Picker {
            Picker(textColor: .white, lineColor: .clear)
        }
    }
}
