//
//  GradientManager.swift
//  Rise
//
//  Created by Vladimir Korolev on 08/06/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit
import AnimatedGradientView

struct GradientManager {
    
    // MARK: Properties
    public var frame: CGRect!
    
    private var arrayManager: ArrayManager<AnimatedGradientViewDirection>?
    
    private var gradientView: AnimatedGradientView?
    
    // MARK: LifeCycle
    init(frame: CGRect) {
        
        self.frame = frame
        
        gradientView = AnimatedGradientView(frame: frame)
    }
    
    // MARK: Methods
    public func createStaticGradient(colors array: [UIColor],
                                     direction: AnimatedGradientViewDirection,
                                     alpha: CGFloat)
        -> UIView {
            
            gradientView?.colors = [array]
            gradientView?.direction = direction
            gradientView?.alpha = alpha
            
            return gradientView ?? UIView()
    }
    
    public func createStaticGradientImage(colors array: [UIColor],
                                          direction: AnimatedGradientViewDirection,
                                          alpha: CGFloat)
        -> UIImage {
            
            return createStaticGradient(colors: array, direction: direction, alpha: alpha).asImage()
    }
    
    mutating public func createAnimatedGradient(colors colorsArray: [[UIColor]],
                                                directions directionsArray: [AnimatedGradientViewDirection])
        -> UIView {
            
            guard colorsArray.count == directionsArray.count else {
                fatalError("Input data doesnt match")
            }
            
            arrayManager = ArrayManager(colors: colorsArray, directions: directionsArray, type: .axial)
            gradientView?.animationValues = arrayManager?.createGradientParameters()
            
            return gradientView ?? UIView()
            
    }
    
}
