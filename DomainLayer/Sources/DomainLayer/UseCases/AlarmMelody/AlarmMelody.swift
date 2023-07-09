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
    
    var name: String {
        switch self {
        case .defaultMelody: return "DefaultMelody"
        }
    }
    
    var type: String {
        switch self {
        case .defaultMelody: return "wav"
        }
    }
    
    var path: URL? {
        switch self {
        case .defaultMelody:
            guard let stringPath = Bundle.main.path(forResource: name, ofType: type) else { assertionFailure("Name melody warning") ; return nil }
            return URL(fileURLWithPath: stringPath)
        }
    }
}
