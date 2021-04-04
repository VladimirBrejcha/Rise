//
//  Styled.swift
//  Rise
//
//  Created by Владимир Королев on 04.04.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

protocol Styleable {
    associatedtype StyleType
    func applyStyle(_ style: StyleType)
}
