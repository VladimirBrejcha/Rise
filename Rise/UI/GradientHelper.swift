//
//  GradientHelper.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

final class GradientHelper {
    // MARK: - Static -
    static func makeDefaultStaticGradient(for frame: CGRect) -> UIView {
        makeStaticGradient(for: frame, with: [Color.darkPurple, Color.darkPink], direction: .up, alpha: 1)
    }
    
    static func makeStaticGradient(
        for frame: CGRect,
        with colors: [UIColor],
        direction: AnimatedGradientViewDirection,
        alpha: CGFloat
    ) -> UIView {
        let gradientView = AnimatedGradientView(frame: frame)
        gradientView.colors = [colors]
        gradientView.direction = direction
        gradientView.alpha = alpha
        return gradientView
    }
    
    // MARK: - Animated -
    static func makeDefaultAnimatedGradient(for frame: CGRect) -> UIView {
        makeAnimatedGradient(for: frame,
                             with: [[Color.darkPurple, Color.darkPink],
                                    [Color.darkPurple, Color.purple],
                                    [Color.purple, Color.darkPurple],
                                    [Color.darkPurple, Color.darkPink]],
                             and:[.up, .upLeft, .upRight, .up])
    }
    
    static func makeAnimatedGradient(
        for frame: CGRect,
        with colors: [[UIColor]],
        and directions: [AnimatedGradientViewDirection]
    ) -> UIView {
        guard colors.count == directions.count
            else {
                log(.error, with: "colors count doesnt match directions count, returning empty view")
                return UIView()
        }
        
        let gradientView = AnimatedGradientView(frame: frame)
        gradientView.animationValues = makeGradientParameters(from: colors, with: directions, and: .axial)
        
        return gradientView
    }
    
    // MARK: - Private -
    private typealias GradientParameters = (colors: [String], AnimatedGradientViewDirection, CAGradientLayerType)
    
    private static func makeGradientParameters(
        from colors: [[UIColor]],
        with directions: [AnimatedGradientViewDirection],
        and type: CAGradientLayerType) -> [GradientParameters]
    {
        let colorStringsArray = convertColorsToHexes(colors)
        
        return colorStringsArray
            .enumerated()
            .map { (index, array) -> GradientParameters in
                (colors: array, directions[index], type)
        }
    }
    
    private static func convertColorsToHexes(_ colors: [[UIColor]]) -> [[String]] {
        return colors.map { $0.map { $0.hexString } }
    }
}

fileprivate extension UIColor {
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
