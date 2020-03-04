//
//  LocationRepository.swift
//  Rise
//
//  Created by Владимир Королев on 04.03.2020.
//  Copyright © 2020 VladimirBrejcha. All rights reserved.
//

import Foundation

protocol LocationRepository {
    func get(_ completion: @escaping (Result<Location, Error>) -> Void)
    @discardableResult func save(location: Location) -> Bool
    @discardableResult func deleteAll() -> Bool
}
