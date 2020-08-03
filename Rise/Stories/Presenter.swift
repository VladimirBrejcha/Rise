//
//  StoryPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 27.12.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class Presenter {
    enum PresentationStyle {
        case fullScreen
        case modal
        case overContext
        case none
    }
    
    static func present(controller: UIViewController,
                       with style: PresentationStyle,
                       presentingController: UIViewController,
                       animated: Bool = true,
                       completion: (() -> Void)? = nil
    ) {
        switch style {
        case .fullScreen:
            presentingController.modalPresentationStyle = .fullScreen
            controller.modalPresentationStyle = .fullScreen
            presentingController.present(controller, animated: animated, completion: completion)
        case .modal:
            presentingController.modalPresentationStyle = .pageSheet
            presentingController.present(controller, animated: animated, completion: completion)
        case .overContext:
            presentingController.modalPresentationStyle = .overCurrentContext
            controller.modalPresentationStyle = .overCurrentContext
            presentingController.present(controller, animated: animated, completion: completion)
        case .none:
            presentingController.modalPresentationStyle = .none
            presentingController.present(controller, animated: animated, completion: completion)
        }
    }
}
