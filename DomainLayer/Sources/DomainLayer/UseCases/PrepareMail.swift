import MessageUI
import Core
import Localization

public protocol HasPrepareMail {
  var prepareMail: PrepareMail { get }
}

public enum PrepareMailError: LocalizedError {
  case cannotSendMail

  public var errorDescription: String? {
    switch self {
    case .cannotSendMail:
      return Text.PrepareMailError.cannotSend
    }
  }
}

public protocol PrepareMail {
  // returns .success(nil) if MFMailComposeViewController.canSendMail() was false, but mailto: operation succeed
  func callAsFunction(
    to recipient: String,
    subject: String?,
    message: String
  ) -> Result<MFMailComposeViewController?, PrepareMailError>
}

final class PrepareMailUseCase: PrepareMail {
  func callAsFunction(
    to recipient: String,
    subject: String?,
    message: String
  ) -> Result<MFMailComposeViewController?, PrepareMailError> {
    if MFMailComposeViewController.canSendMail() {
      let mailVc = MFMailComposeViewController()
      mailVc.setToRecipients([recipient])
      if let subject = subject {
        mailVc.setSubject(subject)
      }
      mailVc.setMessageBody("<p>\(message)</p>", isHTML: true)
      return .success(mailVc)
    } else if let emailUrl = createEmailUrl(to: recipient, subject: subject, body: message) {
      UIApplication.shared.open(emailUrl)
      return .success(nil)
    } else {
      log(.error, "Couldn't send email")
      return .failure(PrepareMailError.cannotSendMail)
    }
  }

  private func createEmailUrl(to: String, subject: String?, body: String) -> URL? {
    var urlString = "mailto:\(to)"
    if let subjectEncoded = subject?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      urlString += "?subject=\(subjectEncoded)"
    }
    if let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
      urlString += "&body=\(bodyEncoded)"
    }
    if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
      return url
    }
    return nil
  }
}
