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
                                directionsArray: [AnimatedGradientViewDirection]) -> UIView {
        
        guard array.count == directionsArray.count else {
            fatalError("Input data doesnt match")
        }
        
        let colorStringsArray = colorToHex(colorArray: array)
        gradientView?.animationValues = createMainArray(strings: colorStringsArray, directions: directionsArray, type: .axial)
        
        return gradientView ?? UIView()
        
    }
    
    func colorToHex(colorArray: [[UIColor]]) -> [[String]] {
        var innerArray: [String] = []
        var mainArray: [[String]] = []
        for index in colorArray {
            for index in index {
                innerArray.append(index.hexString)
            }
            mainArray.append(innerArray)
            innerArray.removeAll()
        }
        return mainArray
    }
    
    func createMainArray(strings: [[String]],
                         directions: [AnimatedGradientViewDirection],
                         type: CAGradientLayerType) -> [
        (colors: [String],
        AnimatedGradientViewDirection,
        CAGradientLayerType)
        ] {
        
        var newArray: [(colors: [String], AnimatedGradientViewDirection, CAGradientLayerType)] = []
        for (index, array) in strings.enumerated() {
            newArray.append((colors: array, directions[index], .axial))
        }
        return newArray
    }
}

extension UIColor {
    var hexString: String {
        let colorRef = cgColor.components
        let colorR = colorRef?[0] ?? 0
        let colorG = colorRef?[1] ?? 0
        let colorB = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : colorG) ?? 0
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
