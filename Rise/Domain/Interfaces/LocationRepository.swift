//
//  LocationRepository.swift
//  Rise
//
//  Created by Vladimir Korolev on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol LocationRepository {
    func get(
        permissionRequestProvider: @escaping (@escaping (Bool) -> Void) -> Void,
        _ completion: @escaping (Result<Location, Error>) -> Void
    )
    func deleteAll()
}
