//
//  JSONParser.swift
//  Rise
//
//  Created by Владимир Королев on 02/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParser {
    class func convertToJSON(any: Any) -> JSON {
        let json = JSON(any)
        return json
    }
    
    class func parse(json: JSON) -> (sunrise: Int, sunset: Int) {
        guard let sunriseTime = json["daily"]["data"][0]["sunriseTime"].int,
            let sunsetTime = json["daily"]["data"][0]["sunsetTime"].int else { fatalError("couldnt parse JSON") }
        return (sunriseTime, sunsetTime)
    }
}
