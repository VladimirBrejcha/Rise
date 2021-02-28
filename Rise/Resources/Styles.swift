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

    enum Button {
        enum Color {
            enum Title {
                static let normal = #colorLiteral(red: 0.07450980392, green: 0.2078431373, blue: 0.3019607843, alpha: 1)
                static let disabled = UIColor.white
            }
            enum Background {
                static let normal = UIColor.white
            }
        }
        enum TextStyle {
            static let font = UIFont.boldSystemFont(ofSize: 18)
        }
        enum Shadow {
            static let radius: CGFloat = 12
            static let opacity: Float = 0.41
            static let offset = CGSize(width: 0, height: 4)
            static let color = #colorLiteral(red: 0.4431372549, green: 1, blue: 0.8980392157, alpha: 1).cgColor
        }
        static let scaleTransform = CGAffineTransform(scaleX: 0.98, y: 0.95)
        static let cornerRadius: CGFloat = 25
    }
}
