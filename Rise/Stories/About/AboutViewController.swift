//
//  AboutViewController.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

final class AboutViewController:
    UIViewController,
    MFMailComposeViewControllerDelegate,
    ErrorAlertCreatable,
    ErrorAlertPresentable
{
    private var aboutView: AboutView { view as! AboutView }
    private var getAppVersion: GetAppVersion!
    private var prepareMail: PrepareMail!

    private let termsAndConditionsUrlString = "https://www.app-privacy-policy.com/live.php?token=VtZdH0djhNg5Tr4BoQhtPjwzUSGJqH6r"
    private let privacyPolicyUrlString = "https://rise-0.flycricket.io/privacy.html"
    private let openSourceUrlString = "https://www.craft.do/s/mLWjI6dIfOxHCJ"
    private let gitHubUrlString = "https://github.com/VladimirBrejcha/Rise"
    private let linkedInUrlString = "https://www.linkedin.com/in/vladimir-korolev/"
    private let telegramUrlString = "https://t.me/vladimirbrejcha"

    // MARK: - LifeCycle

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

                self.aboutView.deselectAll()

                switch identifier {
                case .termsAndConditions:
                    self.openInBrowser(self.termsAndConditionsUrlString)
                case .privacyPolicy:
                    self.openInBrowser(self.privacyPolicyUrlString)
                case .openSource:
                    self.openInBrowser(self.openSourceUrlString)
                case .gitHub:
                    self.openInBrowser(self.gitHubUrlString)
                case .linkedIn:
                    self.openInBrowser(self.linkedInUrlString)
                case .telegram:
                    self.openInBrowser(self.telegramUrlString)
                case .mailFeedback:
                    self.sendMailFeedback()
                }
            }
        )
    }

    // MARK: - Logic

    private func openInBrowser(_ urlString: String) {
        if let url = URL(string: urlString) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }

    private func sendMailFeedback() {
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
