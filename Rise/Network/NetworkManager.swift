//
//  NetworkManager.swift
//  Rise
//
//  Created by Владимир Королев on 02/09/2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let secretKey = "c9d64be4228a302b2e8bfed7689a0b05"
fileprivate let forecastRequestURLString = "https://api.darksky.net/forecast/"

fileprivate struct RequestModel {
    let forecastRequest = forecastRequestURLString
    let key = secretKey
    var longtitude: String
    var latitude: String
    var time: String
}

fileprivate class RequestManager {
    fileprivate class func buildURL(requestModel: RequestModel) -> URL {
        let urlString = "\(requestModel.forecastRequest)\(requestModel.key)/\(requestModel.latitude),\(requestModel.longtitude),\(requestModel.time)"
        guard let url = URL(string: urlString) else { fatalError("Could'nt build URL from String") }
        return url
    }
    
    fileprivate class func makeRequest(url: URL, responseHandler: @escaping (Swift.Result<Any, Error>) -> Void) {
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                responseHandler(.success(json))
            } else {
                let error = NSError(domain: "Rise", code: 1000, userInfo: ["Description": "nil response"])
                responseHandler(.failure(error))
            }
        }
    }
}

class NetworkManager {
    class func getSunData(location: LocationModel, completion: @escaping (Swift.Result<SunModel, Error>) -> Void) {
        let requestModel = NetworkManager.buildRequestModel(location: location, day: .today)
        let requestURL = RequestManager.buildURL(requestModel: requestModel)
        RequestManager.makeRequest(url: requestURL) { response in
            switch response {
            case let .success(unparsedJSON):
                let json = JSONParser.convertToJSON(any: unparsedJSON)
                let sunTime = JSONParser.parse(json: json)
                let sunrise = DatesConverter.buildDate(timestamp: sunTime.sunrise)
                let sunset = DatesConverter.buildDate(timestamp: sunTime.sunset)
                let dayModel = SunModel(sunrise: sunrise, sunset: sunset)
                completion(.success(dayModel))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private class func buildRequestModel(location: LocationModel, day: SegmentedControlCases) -> RequestModel {
        let date = DatesConverter.buildDate(day: day)
        let timestamp = DatesConverter.buildTimestamp(date: date).description
        let requestModel = RequestModel(longtitude: String(location.longitude.prefix(7)), latitude: String(location.latitude.prefix(7)), time: timestamp)
        return requestModel
    }
}
