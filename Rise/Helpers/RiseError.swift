//
//  RiseError.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

enum RiseError: Error {
    case unknownError
    case cantParseJSON
    case cantBuildURL
    case noDataFound
    case noDataReceived
    case locationAccessDenied
    case failedToCreateDate
    case noPlanForTheDay
    
    var code: Int {
        switch self {
        case .unknownError: return 6000
        case .cantParseJSON: return 6001
        case .cantBuildURL: return 6003
        case .noDataFound: return 6004
        case .noDataReceived: return 6002
        case .locationAccessDenied: return 6005
        case .failedToCreateDate: return 6006
        case .noPlanForTheDay: return 6007
        }
    }
    
    var description: String {
        switch self {
        case .unknownError: return "Unknown error"
        case .cantParseJSON: return "Could'nt parce JSON"
        case .noDataReceived: return "Did'nt receive any data from request"
        case .cantBuildURL: return "Could'nt build URL"
        case .noDataFound: return "Could'nt find any data"
        case .locationAccessDenied: return "Access to location was not granted"
        case .failedToCreateDate: return "Calendar returned nil on attempt to create a date"
        case .noPlanForTheDay: return "Rise plan is not scheduled for the day"
        }
    }
}
