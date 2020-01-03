//
//  StoryPresenter.swift
//  Rise
//
//  Created by Владимир Королев on 27.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum PresentationStyle {
    case fullScreen
    case modal
    case overContext
    case none
}

final class StoryPresenter {
    class func present(story: UIViewController,
                       with style: PresentationStyle,
                       presentingController: UIViewController,
                       animated: Bool = true,
                       completion: (() -> Void)? = nil) {
        switch style {
        case .fullScreen:
            presentingController.modalPresentationStyle = .fullScreen
            presentingController.present(story, animated: animated, completion: completion)
        case .modal:
            presentingController.modalPresentationStyle = .pageSheet
            presentingController.present(story, animated: animated, completion: completion)
        case .overContext:
            presentingController.modalPresentationStyle = .overCurrentContext
            presentingController.present(story, animated: animated, completion: completion)
        case .none:
            presentingController.modalPresentationStyle = .none
            presentingController.present(story, animated: animated, completion: completion)
        }
    }
}
