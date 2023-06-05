//
//  TabBarController.swift
//  Rise
//
//  Created by Vladimir Korolev on 02/06/2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {

    private lazy var backgroundView = View.Background.default.asUIView

    private lazy var appearance: UITabBarAppearance = {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedItemPositioning = .fill
        appearance.compactInlineLayoutAppearance = makeItemAppearance(for: .compactInline)
        appearance.inlineLayoutAppearance = makeItemAppearance(for: .inline)
        appearance.stackedLayoutAppearance = makeItemAppearance(for: .stacked)
        return appearance
    }()

    init(items: [UIViewController], selectedIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = items
        self.selectedIndex = selectedIndex
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.async {
//            getRandomNumber()
//        }
//        func getRandomNumber() {
//            let randomInt = Int.random(in: 0...9)
//            guard randomInt >= 0 && randomInt < NotificationData.notificationTitles.count else { return }
//
//            let title = NotificationData.notificationTitles[randomInt]
//            let description = NotificationData.notificationDescriptions[randomInt]
//            let acceptButton = NotificationData.acceptButtons[randomInt]
//            let cancelButton = NotificationData.cancelButtons[randomInt]
//
//            showTimeToSleepAlert(title, description, acceptButton, cancelButton)
//        }
//
//        func showTimeToSleepAlert(_ title: String,_ message: String,_ okaction: String,_ cancelAction: String) {
//            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let okAction = UIAlertAction(title: okaction, style: .default)
//            let cancelAction = UIAlertAction(title: cancelAction, style: .cancel)
//            ac.addAction(okAction)
//            ac.addAction(cancelAction)
//            present(ac, animated: true)
//        }
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        delegate = self

        view.addSubviews(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.activateConstraints(
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 100),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        )
    }

    private func makeItemAppearance(
        for style: UITabBarItemAppearance.Style
    ) -> UITabBarItemAppearance {
        let appearance = UITabBarItemAppearance(style: style)
        appearance.configureWithDefault(for: style)
        appearance.applyStyle(.usual)
        return appearance
    }
    
    // MARK: - UITabBarControllerDelegate -

    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        ScrollTransition(
            viewControllers: tabBarController.viewControllers,
            backgroundView: backgroundView,
            backgroundTranslationX: 50
        )
    }
}
