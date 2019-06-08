//
//  GradientManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

class GradientManager {
    
    // MARK: Properties
    var frame: CGRect!
    
    var gradientView: AnimatedGradientView?
    
    // MARK: LifeCycle
    init(frame: CGRect) {
        
        self.frame = frame
        
        gradientView = AnimatedGradientView(frame: frame)
    }
    
    // MARK: Methods
    func createStaticGradient(colors array: [UIColor],
                              direction: AnimatedGradientViewDirection,
                              alpha: CGFloat) -> UIView {
        
        gradientView?.colors = [array]
        gradientView?.direction = direction
        gradientView?.alpha = alpha
        
        return gradientView ?? UIView()
    }
    
    func createAnimatedGradient(colors array: [[UIColor]],
                                directions directionsArray: [AnimatedGradientViewDirection]) -> UIView {
        
        guard array.count == directionsArray.count else {
            fatalError("Input data doesnt match")
        }
        
        gradientView?.animationValues = createGradientParameters(strings: array, directions: directionsArray, type: .axial)
        
        return gradientView ?? UIView()
        
    }
    
    // MARK: Data convertion
    func createGradientParameters(strings: [[UIColor]], directions: [AnimatedGradientViewDirection], type: CAGradientLayerType)
        -> [(colors: [String], AnimatedGradientViewDirection, CAGradientLayerType)] {
        
        let colorStringsArray = convertArray(strings)
            
        let gradientParameters = colorStringsArray.enumerated().map { (index, array)
            -> (colors: [String], AnimatedGradientViewDirection, CAGradientLayerType) in
            return (colors: array, directions[index], type)
        }
        
        return gradientParameters
    }
    
    func convertArray(_ array: [[UIColor]]) -> [[String]] {
        
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
