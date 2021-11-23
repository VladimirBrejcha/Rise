//
//  LongPressProgressButton.swift
//  Rise
//
//  Created by Vladimir Korolev on 08.04.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class LongPressProgressButton: UIView, NibLoadable {
    @IBOutlet private weak var button: Button!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var workItem: DispatchWorkItem?
    private var animator: UIViewPropertyAnimator?
    
    var progressCompleted: ((LongPressProgressButton) -> Void)?
    
    var title: String? {
        get { button.title(for: .normal) }
        set { button.setTitle(newValue, for: .normal) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        setupFromNib()
        progressView.layer.cornerRadius = 3
        progressView.clipsToBounds = true
        button.onAnyTouchDown = { [weak self] _ in
            guard let self = self else { return }
            if self.workItem != nil { return }
            self.workItem = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                self.progressCompleted?(self)
                self.workItem = nil
            }
            if let workItem = self.workItem {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: workItem)
                self.progressView.progress = 1
                self.animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                    self.progressView.layoutIfNeeded()
                }
                self.animator?.startAnimation()
            }
        }
        button.onAnyTouchUp = { [weak self] _ in
            guard let self = self else { return }
            if let workItem = self.workItem {
                workItem.cancel()
                self.workItem = nil
                if let animator = self.animator {
                    animator.stopAnimation(true)
                    self.progressView.setProgress(0, animated: false)
                }
            }
        }
    }
}
