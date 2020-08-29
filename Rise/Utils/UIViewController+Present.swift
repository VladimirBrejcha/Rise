//
//  UIViewController+Present.swift
//  Rise
//
//  Created by Владимир Королев on 27.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

extension UIViewController {
    enum PresentationStyle {
        case fullScreen
        case modal
        case overContext
        case none
    }
    
    func present(_ controller: UIViewController,
                 with style: PresentationStyle,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil
    ) {
        switch style {
        case .fullScreen:
            modalPresentationStyle = .fullScreen
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: animated, completion: completion)
        case .modal:
            modalPresentationStyle = .pageSheet
            controller.modalPresentationStyle = .pageSheet
            present(controller, animated: animated, completion: completion)
        case .overContext:
            modalPresentationStyle = .overCurrentContext
            controller.modalPresentationStyle = .overCurrentContext
            present(controller, animated: animated, completion: completion)
        case .none:
            modalPresentationStyle = .none
            controller.modalPresentationStyle = .none
            present(controller, animated: animated, completion: completion)
        }
    }
}
