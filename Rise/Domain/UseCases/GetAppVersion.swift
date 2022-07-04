//
//  GetAppVersion.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol HasGetAppVersion {
  var getAppVersion: GetAppVersion { get }
}

protocol GetAppVersion {
    func callAsFunction() -> String?
}

final class GetAppVersionUseCase: GetAppVersion {
    func callAsFunction() -> String? {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
           let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return "\(appVersion) (\(buildVersion))"
        }
        return nil
    }
}
