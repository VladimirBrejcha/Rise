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
    static func makeGradientView(
        frame: CGRect,
        colors: [UIColor] = [Color.darkPurple, Color.darkPink],
        direction: AnimatedGradientViewDirection = .up,
        alpha: CGFloat = 1
    ) -> UIView {
        let gradientView = AnimatedGradientView(frame: frame)
        gradientView.colors = [colors]
        gradientView.direction = direction
        gradientView.alpha = alpha
        return gradientView
    }
    
    static func makeAnimatedGradientView(
        frame: CGRect,
        colors: [[UIColor]] = [[Color.darkPurple, Color.darkPink],
                               [Color.darkPurple, Color.purple],
                               [Color.purple, Color.darkPurple],
                               [Color.darkPurple, Color.darkPink]],
        directions: [AnimatedGradientViewDirection] = [.up, .upLeft, .upRight, .up]
    ) -> UIView {
        guard colors.count == directions.count
            else {
            log(.error, "colors count doesnt match directions count, returning empty view")
                return UIView()
        }
        
        let gradientView = AnimatedGradientView(frame: frame)
        gradientView.animationValues = makeAnimationValues(from: colors, with: directions, and: .axial)
        
        return gradientView
    }
    
    // MARK: - Private -
    private static func makeAnimationValues(
        from colors: [[UIColor]],
        with directions: [AnimatedGradientViewDirection],
        and type: CAGradientLayerType) -> [AnimatedGradientView.AnimationValue]
    {
        let colorStringsArray = convertColorsToHexes(colors)
        
        return colorStringsArray
            .enumerated()
            .map { (index, array) -> AnimatedGradientView.AnimationValue in
                (colors: array, directions[index], type)
            }
    }
    
    private static func convertColorsToHexes(_ colors: [[UIColor]]) -> [[String]] {
        colors.map { $0.map { $0.hexString } }
    }
}
