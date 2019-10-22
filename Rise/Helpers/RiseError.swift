//
//  RiseError.swift
//  Rise
//
//  Created by Владимир Королев on 12.10.2019.
//  Copyright © 2019 VladimirBrejcha. All rights reserved.
//

import Foundation

fileprivate let errorDomain = Bundle.main.bundleIdentifier!

enum RiseError: Int {
    case unknownError      = 5999
    case cantFormatDate    = 6000
    case cantParseJSON     = 6001
    case cantBuildJSON     = 6002
    case noDataReceived    = 6003
    case cantBuildURL      = 6004
    case noDataFound       = 6005
    case noLocationArrived = 6006
    
    private var description: String {
        switch self {
        case .unknownError      : return "Unknown error"
        case .cantFormatDate    : return "Could'nt formate Date"
        case .cantParseJSON     : return "Could'nt parce JSON"
        case .cantBuildJSON     : return "Could'nt build JSON from Data"
        case .noDataReceived    : return "Did'nt receive any data from request"
        case .cantBuildURL      : return "Could'nt build URL"
        case .noDataFound       : return "Could'nt find any data"
        case .noLocationArrived : return "Location data did'nt arrive"
        }
    }
    
    var localizedDescriptionInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: self.description]
    }
}


extension RiseError {
    static func unknownError() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.unknownError.rawValue,
                       userInfo: RiseError.unknownError.localizedDescriptionInfo)
    }
    
    static func errorCantFormatDate() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.cantFormatDate.rawValue,
                       userInfo: RiseError.cantFormatDate.localizedDescriptionInfo)
    }
    
    static func errorCantParseJSON() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.cantParseJSON.rawValue,
                       userInfo: RiseError.cantParseJSON.localizedDescriptionInfo)
    }
    
    static func errorCantBuildJSON() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.cantBuildJSON.rawValue,
                       userInfo: RiseError.cantBuildJSON.localizedDescriptionInfo)
    }
    
    static func errorNoDataReceived() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.noDataReceived.rawValue,
                       userInfo: RiseError.noDataReceived.localizedDescriptionInfo)
    }
    
    static func errorCantBuildURL() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.cantBuildURL.rawValue,
                       userInfo: RiseError.cantBuildURL.localizedDescriptionInfo)
    }
    
    static func errorNoDataFound() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.noDataFound.rawValue,
                       userInfo: RiseError.noDataFound.localizedDescriptionInfo)
    }
    
    static func errorNoLocationArrived() -> NSError {
        return NSError(domain: errorDomain, code: RiseError.noLocationArrived.rawValue,
                       userInfo: RiseError.noLocationArrived.localizedDescriptionInfo)
    }
}
