//
//  SunTimeRemoteDataSource.swift
//  Rise
//
//  Created by Владимир Королев on 10.11.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let requestURLString = "https://api.sunrise-sunset.org/json"

fileprivate struct SunTimeJSONAdapter: Codable {
    let results: SunTime
}

protocol SunTimeRemoteDataSource {
    func get(for numberOfDays: Int,
             since day: Date,
             for location: Location,
             completion: @escaping (Result<[SunTime], Error>) -> Void)
}

final class DefaultSunTimeRemoteDataSource: SunTimeRemoteDataSource {
    func get(for numberOfDays: Int,
             since day: Date,
             for location: Location,
             completion: @escaping (Result<[SunTime], Error>) -> Void) {
        var returnArray = [SunTime]()

        let group = DispatchGroup()

        DispatchQueue.concurrentPerform(iterations: numberOfDays) { dayNumber in
            group.enter()

            let date = day.appending(days: dayNumber)

            guard let url = self.buildURL(with: location, and: date)
                else {
                    completion(.failure(RiseError.cantBuildURL))
                    group.leave()
                    return
            }

            self.makeSingleRequest(with: url) { result in
                if case .failure (let error) = result {
                    completion(.failure(error))
                    group.leave()
                }

                if case .success (let data) = result {
                    let sunModelResult = self.decode(data: data)
                    if case .failure (let error) = sunModelResult {
                        completion(.failure(error))
                        group.leave()
                    }
                    if case .success (let sunModel) = sunModelResult {
                        returnArray.append(sunModel)
                        group.leave()
                    }
                }
            }
        }

        group.notify(queue: .main) {
            if returnArray.isEmpty {
                completion(.failure(RiseError.noDataReceived))
            }
            else {
                completion(.success(returnArray))
            }
        }
    }
    
    private func makeSingleRequest(with url: URL, completion: @escaping (Result<Data,Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(RiseError.noDataReceived))
            }
        }.resume()
    }
    
    private func buildURL(with location: Location, and date: Date) -> URL? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let latitude = String(location.latitude.prefix(7))
        let longitude = String(location.longitude.prefix(7))

        let formattedDateString = dateFormatter.string(from: date)
        
        return URL(string:"\(requestURLString)?lat=\(latitude)&lng=\(longitude)&date=\(formattedDateString)&formatted=0")
    }
    
    private func decode(data: Data) -> Result<SunTime, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let json = try decoder.decode(SunTimeJSONAdapter.self, from: data)
            return .success(json.results)
        }
        catch {
            return .failure(RiseError.cantParseJSON)
        }
    }
}
