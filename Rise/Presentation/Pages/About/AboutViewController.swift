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

  private let termsAndConditionsUrlString = "https://www.app-privacy-policy.com/live.php?token=VtZdH0djhNg5Tr4BoQhtPjwzUSGJqH6r"
  private let privacyPolicyUrlString = "https://rise-0.flycricket.io/privacy.html"
  private let openSourceUrlString = "https://www.craft.do/s/mLWjI6dIfOxHCJ"
  private let gitHubUrlString = "https://github.com/VladimirBrejcha/Rise"
  private let linkedInUrlString = "https://www.linkedin.com/in/vladimir-korolev/"
  private let telegramUrlString = "https://t.me/vladimirbrejcha"

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
        case .linkedIn:
          openInBrowser(linkedInUrlString)
        case .telegram:
          openInBrowser(telegramUrlString)
        case .mailFeedback:
          sendMailFeedback()
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
