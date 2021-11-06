//
//  SunTimeLocalDataSource.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol SunTimeLocalDataSource {
    func getSunTimes(for dates: [Date]) throws -> [SunTime]
    func save(sunTimes: [SunTime]) throws
    func deleteAll() throws
}
