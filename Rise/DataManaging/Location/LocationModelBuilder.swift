//
//  LocationModelBuilder.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

struct LocationModelBuilder {
    func buildModel(from object: RiseLocation) -> Location {
        return Location(latitude: object.latitude, longitude: object.longitude)
    }
    
    func update(object: RiseLocation, with model: Location) {
        object.latitude = model.latitude
        object.longitude = model.longitude
    }
}
