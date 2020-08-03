//
//  SelectableStackViewButton.swift
//  Rise
//
//  Created by Владимир Королев on 09.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit
import SelectableStackView

final class SelectableStackViewButton: UIButton, ObservableBySelectableStackView {
    var observer: ((ObservableBySelectableStackView) -> Void)?
    var handlingSelfSelection: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    private func sharedInit() {
        addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    @objc private func touchUpInside() {
        observer?(self)
    }
}
