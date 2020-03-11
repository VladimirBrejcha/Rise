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
    case noDataReceived
    case cantBuildURL
    case noDataFound
    case locationAccessDenied
    
    var code: Int {
        switch self {
        case .unknownError: return 6000
        case .cantParseJSON: return 6001
        case .noDataReceived: return 6002
        case .cantBuildURL: return 6003
        case .noDataFound: return 6004
        case .locationAccessDenied: return 6005
        }
    }
    
    var description: String {
        switch self {
        case .unknownError: return "Unknown error"
        case .cantParseJSON: return "Could'nt parce JSON"
        case .noDataReceived: return "Did'nt receive any data from request"
        case .cantBuildURL: return "Could'nt build URL"
        case .noDataFound: return "Could'nt find any data"
        case .locationAccessDenied : return "Access to location was not granted"
        }
    }
}
