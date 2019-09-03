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

struct RequestModel {
    let forecastRequest = forecastRequestURLString
    let key = secretKey
    var longtitude: String
    var latitude: String
    var time: String
}

struct OneDaySunModel {
    var sunrise: Date
    var sunset: Date
}

fileprivate class RequestManager {
    fileprivate func buildURL(requestModel: RequestModel) -> URL {
        let urlString = requestModel.forecastRequest + requestModel.key + "/" + requestModel.latitude + "," + requestModel.longtitude + "," + requestModel.time
        guard let url = URL(string: urlString) else { fatalError("Could'nt build URL from String") }
        return url
    }
    
    fileprivate func makeARequest(url: URL, responseHandler: @escaping (Swift.Result<Any, Error>) -> Void) {
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

class NetworkingManager {
    fileprivate let requestManager = RequestManager()
    fileprivate let parser = JSONParser()
    fileprivate let locationManager = sharedLocationManager
    fileprivate let calendar = Calendar.current
    fileprivate let todayDate = Date()
    
    func getSunData(completion: @escaping (Swift.Result<OneDaySunModel, Error>) -> Void) {
        let requestModel = buildRequestModel(day: .today)
        let requestURL = requestManager.buildURL(requestModel: requestModel)
        print(requestURL)
        requestManager.makeARequest(url: requestURL) { response in
            switch response {
            case let .success(unparsedJSON):
                let json = self.parser.convertToJSON(any: unparsedJSON)
                let time = self.parser.parse(json: json)
                let sunrise = self.buildDate(timestamp: time.sunrise)
                let sunset = self.buildDate(timestamp: time.sunset)
                let dayModel = OneDaySunModel(sunrise: sunrise, sunset: sunset)
                completion(.success(dayModel))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func buildDate(timestamp: Int) -> Date {
        return Date(timeIntervalSince1970: Double(timestamp))
    }

    func buildTime(day: SegmentedControlCases) -> Date {
        switch day {
        case .yesterday:
            guard let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: todayDate) else { fatalError("couldnt build yesterday date") }
            return yesterdayDate
        case .today:
            return todayDate
        case .tomorrow:
            guard let tomorrowDate = calendar.date(byAdding: .day, value: 1, to: todayDate) else { fatalError("couldnt build tomorrow date") }
            return tomorrowDate
        }
    }
    
    func createStringTimestamp(date: Date) -> String {
        return Int(date.timeIntervalSince1970).description
    }
    
    func buildRequestModel(day: SegmentedControlCases) -> RequestModel {
        guard let location = locationManager.latestLocation else { fatalError("latest location is nil") }
        let date = buildTime(day: day)
        let timestamp = createStringTimestamp(date: date)
        let requestModel = RequestModel(longtitude: String(location.longitude.prefix(7)), latitude: String(location.latitude.prefix(7)), time: timestamp)
        return requestModel
    }
    
    func askForASunData(requestModel: RequestModel) {
        
    }
    
}
