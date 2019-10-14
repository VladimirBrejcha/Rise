//
//  SunAPIService.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate typealias JSON = [[String: Any]]

fileprivate let host = "sun.p.rapidapi.com"
fileprivate let requestURLString = "https://sun.p.rapidapi.com/api/sun/"

class SunAPIService: SunTimeDataSource {
    private let headers = ["x-rapidapi-host": host, "x-rapidapi-key": SunAPIKey]
    
    func requestSunForecast(for numberOfDays: Int, at startingDate: Date, with location: LocationModel,
                              completion: @escaping (Result<[SunTimeModel], Error>) -> Void) {
        
        var returnArray: [SunTimeModel] = []
        
        let group = DispatchGroup()

        DispatchQueue.concurrentPerform(iterations: numberOfDays) { dayNumber in
            group.enter()
            
            guard let date = Calendar.current.date(byAdding: .day, value: dayNumber - 1, to: startingDate)
                else {
                    completion(.failure(RiseError.errorCantFormatDate()))
                    group.leave()
                    return
            }
            
            guard let url = buildURL(with: location, and: date)
                else {
                    completion(.failure(RiseError.errorCantBuildURL()))
                    group.leave()
                    return
            }
            
            makeSingleRequest(with: url) { result in
                if case .failure (let error) = result { completion(.failure(error)) }
                else if case .success (let data) = result
                {
                    let sunModelResult = self.buildSunModel(from: data, and: date)
                    if case .failure (let error) = sunModelResult { completion(.failure(error)) }
                    else if case .success (let sunModel) = sunModelResult { returnArray.append(sunModel) }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if returnArray.isEmpty { completion(.failure(RiseError.errorNoDataReceived())) }
            else { completion(.success(returnArray)) }
        }
    }
    
    private func makeSingleRequest(with url: URL, completion: @escaping (Result<Data,Error>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: buildRequest(with: url))
        { (data, response, error) in
            if let error = error { completion(.failure(error)) }
            else {
                guard let httpResponse = response as? HTTPURLResponse else { fatalError() } // TODO: - completion - error
                guard let data = data else { fatalError() } // TODO: - completion - error
//                print(httpResponse)
                completion(.success(data))
            }
        }
        dataTask.resume()
    }
    
    private func buildRequest(with url: URL) -> URLRequest {
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    private func buildURL(with location: LocationModel, and date: Date) -> URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let latitude = String(location.latitude.prefix(7))
        let longitude = String(location.longitude.prefix(7))

        let formattedDateString = dateFormatter.string(from: date)
        
        return URL(string:"\(requestURLString)?latitude=\(latitude)&longitude=\(longitude)&date=\(formattedDateString)")
    }
    
    private func buildSunModel(from data: Data, and date: Date) -> Result<SunTimeModel, Error> {
        let jsonResult = buildJSON(from: data)
        if case .failure (let error) = jsonResult { return .failure(error) }
        else if case .success (let json) = jsonResult
        {
            let jsonValues = parseJSON(json)
            guard let jsonSunrise = jsonValues.sunrise,
                let jsonSunset = jsonValues.sunset else { return .failure(RiseError.errorCantParseJSON()) }
            guard let sunrise = buildDate(from: jsonSunrise),
                let sunset = buildDate(from: jsonSunset) else { return .failure(RiseError.errorCantFormatDate()) }
            
            return .success(SunTimeModel(day: date, sunrise: sunrise, sunset: sunset))
        }
        else { return .failure(RiseError.unknownError()) }
    }
    
    private func parseJSON(_ json: JSON) -> (sunrise: String?, sunset: String?) {
        let sunset = json[1]["sunset"] as? String
        let sunrise = json[3]["sunrise"] as? String
        return (sunrise: sunrise, sunset: sunset)
    }
    
    private func buildJSON(from data: Data) -> Result<JSON, Error> {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: [])
                as? JSON else { return .failure(RiseError.errorCantBuildJSON()) }
            return .success(json) }
        catch { return .failure(error) }
    }
    
    private func buildDate(from string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
}
