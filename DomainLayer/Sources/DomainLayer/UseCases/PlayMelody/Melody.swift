import Foundation

public enum Melody: String {
    
    case rise
    case roosters
    case softMagical
    case oldAlarm
    case tiktak
    case thunderstorm
    case rainAndBirds

    public var localizedName: String {
        switch self {
        case .rise:
            return "Rise and Shine!"
        case .roosters:
            return "Roosters Crow"
        case .softMagical:
            return "Soft Magical Melody"
        case .oldAlarm:
            return "Old Alarm"
        case .tiktak:
            return "Tik Tak"
        case .thunderstorm:
            return "Thunderstorm"
        case .rainAndBirds:
            return "Rain and Birds"
        }
    }
    
    var type: String {
        switch self {
        case .softMagical, .thunderstorm, .rainAndBirds:
            return "mp3"
        default:
            return "wav"
        }
    }
    
    var path: URL? {
        guard let stringPath = Bundle.main.path(
            forResource: rawValue,
            ofType: type
        ) else {
            assertionFailure("Name melody warning")
            return nil
        }
        return URL(fileURLWithPath: stringPath)
    }
}
