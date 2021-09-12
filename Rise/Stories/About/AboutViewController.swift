//
//  AboutViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {

    private var aboutView: AboutView { view as! AboutView }
    private var getAppVersion: GetAppVersion!

    convenience init(getAppVersion: GetAppVersion) {
        self.init(nibName: nil, bundle: nil)
        self.getAppVersion = getAppVersion
    }

    override func loadView() {
        super.loadView()
        self.view = AboutView(
            model: .init(
                logo: Asset.launchScreenLogo.image,
                name: "Rise",
                appVersion: getAppVersion(),
                legalItems: [
                    .init(
                        identifier: .termsAndConditions,
                        text: Text.About.Legal.termsAndConditions
                    ),
                    .init(
                        identifier: .privacyPolicy,
                        text: Text.About.Legal.privacyPolicy
                    ),
                    .init(
                        identifier: .openSource,
                        text: Text.About.Legal.openSource
                    )
                ],
                socialItems: [
                    .init(
                        identifier: .gitHub,
                        text: Text.About.Social.github
                    ),
                    .init(
                        identifier: .linkedIn,
                        text: Text.About.Social.linkedIn
                    ),
                    .init(
                        identifier: .telegram,
                        text: Text.About.Social.telegram
                    )
                ],
                feedbackItems: [
                    .init(
                        identifier: .mailFeedback,
                        text: Text.About.Feedback.mail
                    )
                ]
            ),
            selectionHandler: { identifier in
                print(identifier)
            }
        )
    }
}
