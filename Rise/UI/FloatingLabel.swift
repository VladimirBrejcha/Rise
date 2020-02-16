//
//  FloatingLabel.swift
//  Rise
//
//  Created by Владимир Королев on 16.02.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class FloatingLabel: UILabel {
    var dataSource: (() -> (text: String, alpha: Float))? {
        didSet {
            guard let source = dataSource
                else {
                    timer?.invalidate()
                    animation?.animate(false)
                    textToShow = ""
                    alphaToUse = 0
                    return
            }
            
            timer = Timer.scheduledTimer(
                withTimeInterval: 2,
                repeats: true
            ) { [weak self] timer in
                guard let self = self
                    else {
                        timer.invalidate()
                        return
                }
                let data = source()
                self.textToShow = data.text
                self.alphaToUse = CGFloat(data.alpha)
            }
            timer?.fire()
            animation = VerticalPositionMoveAnimation(with: layer, from: 4, to: 0, duration: 2.4)
            animation?.animate(true)
        }
    }
    
    private var animation: Animation?
    private var timer: Timer?
    private var textToShow: String = "" {
        didSet {
            text = textToShow
        }
    }
    
    private var alphaToUse: CGFloat = 0 {
        didSet {
            UIView.animate(withDuration: 1, delay: 1, options: [.allowUserInteraction], animations: {
                self.alpha = self.alphaToUse
            }, completion: nil)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}
