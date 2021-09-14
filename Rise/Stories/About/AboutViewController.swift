//
//  AboutViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import MessageUI

final class AboutViewController: UIViewController, MFMailComposeViewControllerDelegate {

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
            selectionHandler: { [weak self] identifier in
                guard let self = self else { return }
                switch identifier {
                case .mailFeedback:
                    self.sendEmail()
                default:
                    return
                }
                print(identifier)
            }
        )
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["vladimirbrejcha@icloud.com"])
            mail.setMessageBody("<p>Hello, I'm using Rise v\(getAppVersion() ?? "") and have some feedback.</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            log(.error, "Couldn't send email")
            // show failure alert
        }
    }

    // MARK: - MFMailComposeViewControllerDelegate

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        log(.info, "mailComposeController didFinish with result: \(result.rawValue), error: \(String(describing: error))")
        controller.dismiss(animated: true)
    }
}
