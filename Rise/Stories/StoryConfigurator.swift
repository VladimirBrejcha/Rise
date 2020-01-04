//
//  MainScreenConfigurator.swift
//  Rise
//
//  Created by Владимир Королев on 08.12.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import UIKit

final class StoryConfigurator {
    class func configure(story: Story) -> UIViewController {
        switch story {
        case .today:
            let controller = Storyboard.main.get().instantiateViewController(of: TodayStoryViewController.self)
            let presenter = TodayStoryPresenter(view: controller)
            presenter.requestSunTimeUseCase = sharedUseCaseManager
            presenter.requestPersonalPlanUseCase = sharedUseCaseManager
            presenter.receivePersonalPlanUpdates = sharedUseCaseManager
            controller.output = presenter
            return controller
        case .plan:
            let controller = Storyboard.main.get().instantiateViewController(of: PersonalPlanViewController.self)
            let presenter = PersonalPlanPresenter(view: controller)
            controller.output = presenter
            return controller
        case .settings:
            let controller = Storyboard.settings.get().instantiateViewController(of: SettingsViewController.self)
            let presenter = SettingsPresenter(view: controller)
            controller.output = presenter
            return controller
        case .setupPlan:
            let controller = Storyboard.plan.get().instantiateViewController(of: SetupPlanViewController.self)
            let presenter = SetupPlanPresenter(view: controller)
            presenter.stories = [.welcomeSetupPlan,
                                 .sleepDurationSetupPlan(sleepDurationOutput: presenter.sleepDurationValueChanged(_:)),
                                 .wakeUpTimeSetupPlan(wakeUpTimeOutput: presenter.wakeUpTimeValueChanged(_:)),
                                 .planDurationSetupPlan(planDurationOutput: presenter.planDurationValueChanged(_:)),
                                 .wentSleepSetupPlan(wentSleepOutput: presenter.lastTimeWentSleepValueChanged(_:)),
                                 .planCreatedSetupPlan]
            controller.output = presenter
            return controller
        case .welcomeSetupPlan:
            let controller = Storyboard.plan.get().instantiateViewController(of: WelcomeSetuplPlanViewController.self)
            return controller
        case .sleepDurationSetupPlan(let sleepDurationOutput):
            let controller = Storyboard.plan.get().instantiateViewController(of: SleepDurationSetupPlanViewController.self)
            controller.sleepDurationOutput = sleepDurationOutput
            return controller
        case .wakeUpTimeSetupPlan(let wakeUpTimeOutput):
            let controller = Storyboard.plan.get().instantiateViewController(of: WakeUpTimeSetupPlanViewController.self)
            controller.wakeUpTimeOutput = wakeUpTimeOutput
            return controller
        case .planDurationSetupPlan(let planDurationOutput):
            let controller = Storyboard.plan.get().instantiateViewController(of: PlanDurationSetupPlanViewController.self)
            controller.planDurationOutput = planDurationOutput
            return controller
        case .wentSleepSetupPlan(let wentSleepOutput):
            let controller = Storyboard.plan.get().instantiateViewController(of: WentSleepSetupPlanViewController.self)
            controller.wentSleepTimeOutput = wentSleepOutput
            return controller
        case .planCreatedSetupPlan:
            let controller = Storyboard.plan.get().instantiateViewController(of: PlanCreatedSetupPlanViewController.self)
            return controller
        }
    }
}

extension UIStoryboard {
    func instantiateViewController(withIdentifier typeIdentifier: UIViewController.Type) -> UIViewController {
        return instantiateViewController(withIdentifier: String(describing: typeIdentifier))
    }
    
    func instantiateViewController<Type: UIViewController>(of type: Type.Type) -> Type {
        return instantiateViewController(withIdentifier: String(describing: type)) as! Type
    }
}
