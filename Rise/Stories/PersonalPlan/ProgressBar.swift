//
//  ProgressBar.swift
//  Rise
//
//  Created by Владимир Королев on 12/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ProgressBar: UIView {
    private let progressView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
        addSubview(progressView)
        
        progressView.layer.cornerRadius = (frame.height / 2)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: -frame.width + 25).isActive = true
        progressView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        progressView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        progressView.backgroundColor = Color.violet
    }
    
    func showProgress(progress: CGFloat) {
        UIView.animate(withDuration: TimeInterval(progress * 3), delay: 0, options: [.allowUserInteraction, .curveEaseInOut, .preferredFramesPerSecond60, .transitionFlipFromRight], animations: {
            self.progressView.transform = CGAffineTransform(translationX: self.frame.width * progress, y: 0)
        }, completion: nil)
    }
}
