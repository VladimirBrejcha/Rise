//
//  ArrayManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

struct ArrayManager<GradientDirection> {
    
    // MARK: Properties
    public let colors: [[UIColor]]
    public let directions: [GradientDirection]
    public let type: CAGradientLayerType
    
    // MARK: Methods
    public func createGradientParameters() -> [(colors: [String], GradientDirection, CAGradientLayerType)] {
            
            let colorStringsArray = convertArray(colors)
            
            let gradientParameters = colorStringsArray.enumerated().map { (index, array)
                -> (colors: [String], GradientDirection, CAGradientLayerType) in
                return (colors: array, directions[index], type)
            }
            
            return gradientParameters
    }
    
    public func convertArray(_ array: [[UIColor]]) -> [[String]] {
        
        let convertedArray = array.map { array -> [String] in
            array.map { color -> String in
                color.hexString
            }
        }
        
        return convertedArray
    }
    
}

// MARK: Extensions
extension UIColor {
    var hexString: String { //UIColor -> Hex String
        let colorRef = cgColor.components
        let colorR = colorRef?[0] ?? 0
        let colorG = colorRef?[1] ?? 0
        let colorB
            = ((colorRef?.count ?? 0) > 2
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
