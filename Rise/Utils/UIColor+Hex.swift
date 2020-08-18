//
//  UIColor+hex.swift
//  Rise
//
//  Created by Владимир Королев on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIColor {
    var hexString: String {
        let colorRef = cgColor.components
        let colorR = colorRef?[0] ?? 0
        let colorG = colorRef?[1] ?? 0
        let colorB = ((colorRef?.count ?? 0) > 2
            ? colorRef?[2]
            : colorG) ?? 0
        
        let colorA = cgColor.alpha
        
        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(colorR * 255)),
            lroundf(Float(colorG * 255)),
            lroundf(Float(colorB * 255))
        )
        
        if colorA < 1 {
            color += String(format: "%02lX", lroundf(Float(colorA)))
        }
        
        return color
    }
}
