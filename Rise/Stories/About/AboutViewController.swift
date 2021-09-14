//
//  AboutViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import MessageUI

final class AboutViewController:
    UIViewController,
    MFMailComposeViewControllerDelegate,
    ErrorAlertCreatable,
    ErrorAlertPresentable
{
    private var aboutView: AboutView { view as! AboutView }
    private var getAppVersion: GetAppVersion!
    private var prepareMail: PrepareMail!

    convenience init(
        getAppVersion: GetAppVersion,
        prepareMail: PrepareMail
    ) {
        self.init(nibName: nil, bundle: nil)
        self.getAppVersion = getAppVersion
        self.prepareMail = prepareMail
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
            selectionHandler: { [weak self] identifier in
                guard let self = self else { return }
                switch identifier {
                case .mailFeedback:
                    self.sendMailFeedback()
                default:
                    return
                }
                print(identifier)
            }
        )
    }

    func sendMailFeedback() {
        let result = prepareMail(
            to: "vladimirbrejcha@icloud.com",
            subject: "Feedback",
            message: "Hello, I'm using Rise v\(getAppVersion() ?? "") and have some feedback."
        )
        if case let .success(mailVc) = result {
            if let mailVc = mailVc {
                mailVc.mailComposeDelegate = self
                present(mailVc, animated: true)
            }
        } else if case let .failure(error) = result {
            presentAlert(from: error)
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        log(.info,
            "mailComposeController didFinish with result: \(result.rawValue), error: \(String(describing: error))"
        )
        controller.dismiss(animated: true)
    }
}
