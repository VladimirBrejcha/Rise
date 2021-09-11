//
//  GetAppVersion.swift
//  Rise
//
//  Created by Vladimir Korolev on 12.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol GetAppVersion {
    func callAsFunction() -> String?
}

final class GetAppVersionUseCase: GetAppVersion {
    func callAsFunction() -> String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
