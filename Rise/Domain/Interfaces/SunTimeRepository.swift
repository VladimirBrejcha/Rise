//
//  SunTimeRepository.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

typealias SunTimesResult = Result<[SunTime], SunTimeError>

protocol SunTimeRepository {
    func requestSunTimes(
        dates: [Date],
        location: Location,
        completion: @escaping (SunTimesResult) -> Void
    )
    func deleteAll() throws
}
