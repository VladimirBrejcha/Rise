//
//  MainScreenConfigurator.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

enum PresentationStory {
    case today
    case plan
    case settings
}

final class StoryConfigurator {
    class func createAndConfigure(module: PresentationStory) -> UIViewController {
        switch module {
        case .today:
            let controller = Storyboard.main.get().instantiateViewController(withIdentifier: TodayStoryViewController.self)
                as! TodayStoryViewController
            let presenter = TodayStoryPresenter(view: controller)
            presenter.requestSunTimeUseCase = sharedUseCaseManager
            presenter.requestPersonalPlanUseCase = sharedUseCaseManager
            controller.output = presenter
            return controller
        case .plan:
            let controller = Storyboard.plan.get().instantiateViewController(withIdentifier: PersonalPlanViewController.self)
                as! PersonalPlanViewController
            let presenter = PersonalPlanPresenter(view: controller)
            controller.output = presenter
            return controller
        case .settings:
            let controller = Storyboard.settings.get().instantiateViewController(withIdentifier: SettingsViewController.self)
                as! SettingsViewController
            let presenter = SettingsPresenter(view: controller)
            controller.output = presenter
            return controller
        }
    }
}

fileprivate extension UIStoryboard {
    func instantiateViewController(withIdentifier typeIdentifier: UIViewController.Type) -> UIViewController {
        return instantiateViewController(withIdentifier: String(describing: typeIdentifier))
    }
}
