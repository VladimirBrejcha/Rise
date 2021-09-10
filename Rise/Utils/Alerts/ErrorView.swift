//
//  ErrorView.swift
//  Rise
//
//  Created by Vladimir Korolev on 18.08.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class ErrorView: UIView {
    struct Action {
        let title: String
        let action: (() -> Void)?
    }
    
    convenience init(title: String?, description: String?, actions: [ErrorView.Action]) {
        let width = UIScreen.main.bounds.width
        self.init(frame: CGRect(x: 0, y: 0, width: width, height: 400))
//
//        _titleLabel.text = title
//        _descriptionLabel.text = description
//        actions.forEach { (action) in
//            let button = RecoverableButton(touchUpInsideBlock: action.action)
//            button.setTitle(action.title, for: .normal)
//            button.touchUpInsideBlock = action.action
//
//            _setup(button: button)
//            _buttonsStackView.addArrangedSubview(button)
//        }
//        _infoImageView.image = UIImage(named: "img_tech_work")
    }
}
