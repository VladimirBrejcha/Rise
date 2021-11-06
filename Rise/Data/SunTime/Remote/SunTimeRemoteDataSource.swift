//
//  SunTimeRemoteDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 10.11.2019.
//  Copyright © 2019-2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias SunTimeRemoteResult = Result<[SunTime], NetworkError>

protocol SunTimeRemoteDataSource {
    func requestSunTimes(
        for dates: [Date],
        location: Location,
        completion: @escaping (SunTimeRemoteResult) -> Void
    )
}
