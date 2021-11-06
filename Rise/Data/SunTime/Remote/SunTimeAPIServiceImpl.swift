//
//  SunTimeAPIServiceImpl.swift
//  Rise
//
//  Created by Vladimir Korolev on 19.09.2021.
//  Copyright © 2021 VladimirBrejcha. All rights reserved.
//

import Foundation

final class SunTimeAPIServiceImpl: SunTimeRemoteDataSource {

    func requestSunTimes(
        for dates: [Date],
        location: Location,
        completion: @escaping (SunTimeRemoteResult) -> Void
    ) {
        var requestResult = [SunTime]()
        var requestError: NetworkError?

        let group = DispatchGroup()

        DispatchQueue.concurrentPerform(iterations: dates.count) { dayNumber in
            group.enter()

            let date = dates[dayNumber]

            Self.requestSunTime(for: date, location: location) { result in
                if case let .success(sunTime) = result {
                    requestResult.append(sunTime)
                }
                if case let .failure(error) = result {
                    requestError = error
                }
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.global(qos: .default)) {
            if let error = requestError {
                completion(.failure(error))
            } else {
                completion(.success(requestResult))
            }
        }
    }

    private static func requestSunTime(
        for date: Date,
        location: Location,
        completion: @escaping (Result<SunTime, NetworkError>) -> Void
    ) {
        log(.info, "date: \(date), location: \(location)")
        let urlResult = buildURL(location: location, date: date)

        if case let .failure(error) = urlResult {
            completion(.failure(error))
        }

        if case let .success(url) = urlResult {
            makeRequest(url: url) { result in
                if case let .failure(error) = result {
                    completion(.failure(error))
                }

                if case let .success (data) = result {
                    let decodingResult = decode(data: data)
                    if case let .success(sunTime) = decodingResult {
                        completion(.success(sunTime))
                    }
                    if case let .failure(error) = decodingResult {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    private static func makeRequest(url: URL, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(NetworkError.urlSessionError(underlyingError: error)))
                return
            }
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noDataReceived))
            }
        }.resume()
    }

    private static func buildURL(location: Location, date: Date) -> Result<URL, NetworkError> {
        let apiUrl = "https://api.sunrise-sunset.org/json"

        let latitude = String(location.latitude.prefix(7))
        let longitude = String(location.longitude.prefix(7))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDateString = dateFormatter.string(from: date)

        let urlString = "\(apiUrl)?lat=\(latitude)&lng=\(longitude)&date=\(formattedDateString)&formatted=0"

        if let url = URL(string: urlString) {
            return .success(url)
        } else {
            return .failure(NetworkError.incorrectUrl(url: urlString))
        }
    }

    private static func decode(data: Data) -> Result<SunTime, NetworkError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decoded = try decoder.decode(SunTimeJSONAdapter.self, from: data)
            return .success(decoded.results)
        }
        catch (let error) {
            return .failure(NetworkError.responseParsingError(underlyingError: error))
        }
    }

    private struct SunTimeJSONAdapter: Decodable {
        let results: SunTime
    }
}
