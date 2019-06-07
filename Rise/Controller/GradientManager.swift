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
    
    var gradientView: AnimatedGradientView?
    
    func createStaticGradient(colors: [UIColor], direction: AnimatedGradientViewDirection, alpha: CGFloat, frame: CGRect) -> UIView {
        gradientView = AnimatedGradientView(frame: frame)
        gradientView?.colors = [colors]
        gradientView?.direction = direction
        gradientView?.alpha = alpha
        
        return gradientView ?? UIView()
    }
}
