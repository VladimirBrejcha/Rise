//
//  SunTimeAPIService.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias SunTimeAPIServiceResult = Result<[SunTime], NetworkError>

protocol SunTimeAPIService {
    func requestSunTimes(
        for dates: [Date],
        location: Location,
        completion: @escaping (SunTimeAPIServiceResult) -> Void
    )
}
