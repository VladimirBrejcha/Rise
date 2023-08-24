import DataLayer

public protocol HasSelectAlarmMelody {
    var selectAlarmMelody: SelectAlarmMelody { get }
}

public protocol SelectAlarmMelody {
    var melodies: [Melody] { get }
    var selectedMelody: Melody { get }
    func callAsFunction(_ melody: Melody)
}

final class SelectAlarmMelodyImpl: SelectAlarmMelody {

    private let userData: UserData

    init(userData: UserData) {
        self.userData = userData
    }

    private(set) var melodies: [Melody] = [
        .roosters, .rise,
        .softMagical, .oldAlarm, .tiktak
    ]

    var selectedMelody: Melody {
        if let selected = userData.selectedAlarmMelody,
           let melody = melodies.first(where: { $0.rawValue == selected }) {
            return melody
        }
        return .rise // default melody
    }

    func callAsFunction(_ melody: Melody) {
        userData.selectedAlarmMelody = melody.rawValue
    }
}
