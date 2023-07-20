//
//  AlarmMelody.swift
//  Rise
//
//  Created by VPDev on 09.07.2023.
//  Copyright © 2023 VladimirBrejcha. All rights reserved.
//

import Foundation

enum AlarmMelody {
    case defaultMelody
    case cockMelody
    case erokiaMelody
    case oldAlarmMelody
    case tiktakMelody
    
    var name: String {
        switch self {
        case .defaultMelody: return "DefaultMelody"
        case .cockMelody: return "cockMelody"
        case .erokiaMelody: return "erokiaMelody"
        case .oldAlarmMelody: return "oldAlarmMelody"
        case .tiktakMelody: return "tiktakMelody"
        }
    }
    
    var type: String {
        switch self {
        case .erokiaMelody: return "mp3"
        default: return "wav"
        }
    }
    
    var path: URL? {
        switch self {
        default:
            guard let stringPath = Bundle.main.path(forResource: name, ofType: type) else { assertionFailure("Name melody warning") ; return nil }
            return URL(fileURLWithPath: stringPath)
        }
    }
}
