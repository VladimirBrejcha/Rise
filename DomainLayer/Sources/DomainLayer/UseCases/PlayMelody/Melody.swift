import Foundation

enum Melody {
    case defaultMelody
    case cockMelody
    case erokiaMelody
    case oldAlarmMelody
    case tiktakMelody
    case thunderstorm
    case rainAndBirds
    
    var name: String {
        switch self {
        case .defaultMelody:
            return "DefaultMelody"
        case .cockMelody:
            return "cockMelody"
        case .erokiaMelody:
            return "erokiaMelody"
        case .oldAlarmMelody:
            return "oldAlarmMelody"
        case .tiktakMelody:
            return "tiktakMelody"
        case .thunderstorm:
            return "thunderstorm"
        case .rainAndBirds:
            return "rainAndBirds"
        }
    }
    
    var type: String {
        switch self {
        case .erokiaMelody: return "mp3"
        case .thunderstorm, .rainAndBirds: return "mp3"
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
