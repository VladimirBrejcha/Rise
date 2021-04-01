//
//  Styles.swift
//  Rise
//
//  Created by Владимир Королев on 20.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

enum Styles {
    enum Label {
        enum Notification {
            static let font = UIFont.boldSystemFont(ofSize: 13)
        }
        enum Title {
            static let color = UIColor.white
            static let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        }
    }
    enum TabBar {
        enum Color {
            enum Title {
                static let selected = UIColor.white
                static let normal = UIColor.clear
            }
            enum Icon {
                static let selected = UIColor.white
                static let normal = UIColor.white.withAlphaComponent(0.85)
            }
        }
    }
}

struct LayerStyle {
    private(set) var shadow = ShadowStyle()
    private(set) var border = BorderStyle()
    private(set) var cornerRadius: CGFloat = 0
}

struct ShadowStyle {
    private(set) var radius: CGFloat = 0
    private(set) var opacity: Float = 0
    private(set) var offset = CGSize(width: 0, height: 0)
    private(set) var color = UIColor.clear.cgColor
}

struct BorderStyle {
    private(set) var color: CGColor = UIColor.clear.cgColor
    private(set) var width: CGFloat = 0
}

struct ColorStyle {
    let normal: UIColor
    let disabled: UIColor
}

struct TextStyle {
    let font: UIFont
}

struct ButtonStyle {
    let titleColor: ColorStyle
    let titleStyle: TextStyle
    let backgroundColor: ColorStyle
    let effects: LayerStyle
    let scaleTransform: CGAffineTransform
}

let primaryButtonStyle: () -> ButtonStyle = {
    ButtonStyle(
        titleColor: ColorStyle(
            normal: #colorLiteral(red: 0.07450980392, green: 0.2078431373, blue: 0.3019607843, alpha: 1),
            disabled: #colorLiteral(red: 0.07450980392, green: 0.2078431373, blue: 0.3019607843, alpha: 1).withAlphaComponent(0.5)
        ),
        titleStyle: TextStyle(
            font: UIFont.boldSystemFont(ofSize: 18)
        ),
        backgroundColor: ColorStyle(
            normal: .white,
            disabled: .white
        ),
        effects: LayerStyle(
            shadow: ShadowStyle(
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

let secondaryButtonStyle: () -> ButtonStyle = {
    ButtonStyle(
        titleColor: ColorStyle(
            normal: UIColor.white,
            disabled: UIColor.white.withAlphaComponent(0.5)
        ),
        titleStyle: TextStyle(
            font: UIFont.boldSystemFont(ofSize: 18)
        ),
        backgroundColor: ColorStyle(
            normal: .clear,
            disabled: .clear
        ),
        effects: LayerStyle(
            border: BorderStyle(
                color: UIColor.white.cgColor,
                width: 1
            ),
            cornerRadius: 25
        ),
        scaleTransform: CGAffineTransform(scaleX: 0.98, y: 0.95)
    )
}
