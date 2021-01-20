//
//  StandartButton.swift
//  Rise
//
//  Created by Владимир Королев on 20.01.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

@IBDesignable
final class StandartButton: Button {
    
    fileprivate typealias Style = Styles.Button

    override func configure() {
        super.configure()
        backgroundColor = Style.Color.Background.normal
        layer.cornerRadius = CGFloat(Style.cornerRadius)
        layer.shadowColor = Style.Shadow.color
        layer.shadowRadius = Style.Shadow.radius
        layer.shadowOpacity = Style.Shadow.opacity
        layer.shadowOffset = Style.Shadow.offset
        setTitleColor(Style.Color.Title.normal, for: .normal)
        setTitleColor(Style.Color.Title.disabled, for: .disabled)
        titleLabel?.font = Style.TextStyle.font
    }
}
