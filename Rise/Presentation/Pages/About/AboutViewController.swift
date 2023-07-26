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
import Core
import DomainLayer
import Localization

final class AboutViewController:
    UIViewController,
    MFMailComposeViewControllerDelegate,
    AlertCreatable,
    AlertPresentable,
    ViewController
{
    typealias Deps = HasGetAppVersion & HasPrepareMail
    typealias View = AboutView

    private let getAppVersion: GetAppVersion
    private let prepareMail: PrepareMail

    private let termsAndConditionsUrlString = "https://blog.vladimirbrejcha.com/rise/terms"
    private let privacyPolicyUrlString = "https://blog.vladimirbrejcha.com/rise/privacy-policy"
    private let openSourceUrlString = "https://blog.vladimirbrejcha.com/rise/open-source"
    private let gitHubUrlString = "https://github.com/VladimirBrejcha/Rise"
    private let telegramUrlString = "https://t.me/vladimirbrejcha"
    private let noubleBushidoUrlString = "https://github.com/Nouble-Bushido"
    private let vladislavUrlString = "https://github.com/VPOneDev"
    private let vladimirBrejchaUrlString = "https://github.com/vladimirBrejcha"

    // MARK: - LifeCycle

    init(deps: Deps) {
        self.getAppVersion = deps.getAppVersion
        self.prepareMail = deps.prepareMail
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()

        self.view = View(
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
                        identifier: .telegram,
                        text: Text.About.Social.telegram
                    )
                ],
                coauthors: [
                    .init(
                        identifier: .vladimirBrejcha,
                        text: Text.About.Coauthors.vladimirBrejcha
                    ),
                    .init(
                        identifier: .noubleBushido,
                        text: Text.About.Coauthors.noubleBushido
                    ),
                    .init(
                        identifier: .vladislav,
                        text: Text.About.Coauthors.vladislav
                    )
                ],
                feedbackItems: [
                    .init(
                        identifier: .mailFeedback,
                        text: Text.About.Feedback.mail
                    )
                ]
            ),
            selectionHandler: { [unowned self] identifier in
                rootView.deselectAll()
                switch identifier {
                case .termsAndConditions:
                    openInBrowser(termsAndConditionsUrlString)
                case .privacyPolicy:
                    openInBrowser(privacyPolicyUrlString)
                case .openSource:
                    openInBrowser(openSourceUrlString)
                case .gitHub:
                    openInBrowser(gitHubUrlString)
                case .telegram:
                    openInBrowser(telegramUrlString)
                case .mailFeedback:
                    sendMailFeedback()
                case .vladimirBrejcha:
                    openInBrowser(vladimirBrejchaUrlString)
                case .noubleBushido:
                    openInBrowser(noubleBushidoUrlString)
                case .vladislav:
                    openInBrowser(vladislavUrlString)
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
